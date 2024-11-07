//
//  PlacesListViewModel.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 17/10/2024.
//
import SwiftUI
import CoreLocation

@Observable @MainActor
final class PlacesListViewModel {

    var state: State = .loading
    var floatingErrorMessage: LocalizedStringKey?

    // Convenience property to get data from state in unit tests
    var data: [Location] {
        guard case .data(let locations) = state else {
            return []
        }
        return locations
    }

    var showAddCustomLocationSheet = false

    private let locationService: LocationServiceProtocol

    private var remoteLocations = [Location]()
    private var customLocations = [Location]()

    enum State {
        case loading
        case data(locations: [Location])
        case empty
        case error(message: LocalizedStringKey)
    }

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }
}

// MARK: - View events

extension PlacesListViewModel {

    func onTask() async {
        await getLocations()
    }

    func onRetryTap() async {
        await getLocations()
    }

    func onLocationTap(_ location: Location, openURLAction: OpenURLAction) {
        openLocation(location, openURLAction: openURLAction)
    }

    func onAddCustomLocationTap() {
        showAddCustomLocationSheet = true
    }

    func onSaveCustomLocationTap(_ newLocation: Location?) {

        guard let location = newLocation else {
            // Field validation is done before the user has the option of even saving a location. No error handling is needed here
            return
        }

        customLocations.append(location)

        updateDataState()

        showAddCustomLocationSheet = false
    }

    func onCancelAddingCustomLocationTap() {
        showAddCustomLocationSheet = false
    }
}

// MARK: - Private functions and properties

private extension PlacesListViewModel {

    func getLocations() async {
        state = .loading

        do {
            let retrievedLocations: [Location] = try await locationService.getLocations()
            remoteLocations = retrievedLocations
            updateDataState()
        } catch {
            showFullScreenError("Error loading locations. Check your internet connection and try again")
        }
    }

    func updateDataState() {
        if remoteLocations.isEmpty && customLocations.isEmpty {
            state = .empty
        } else {
            state = .data(locations: remoteLocations + customLocations)
        }
    }

    func openLocation(_ location: Location, openURLAction: OpenURLAction) {
        guard let url = wikipediaURLForLocation(location) else {
            showFloatingError("The location cannot opened. The location seems to have incorrect coordinates.")
            return
        }

        openURLAction.callAsFunction(url) { [weak self] accepted in
            guard accepted else {
                self?.showFloatingError("The location cannot be opened. Make sure you have the Wikipedia app installed.")
                return
            }
        }
    }

    func wikipediaURLForLocation(_ location: Location) -> URL? {
        guard location.hasValidCoordinate else {
            return nil
        }

        return URL(string: "wikipedia://places/?WMFCoordinate=\(location.latitude),\(location.longitude)")
    }

    func showFloatingError(_ message: LocalizedStringKey) {
        floatingErrorMessage = message
    }

    func showFullScreenError(_ message: LocalizedStringKey) {
        state = .error(message: message)
    }
}
