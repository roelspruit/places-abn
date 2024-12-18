//
//  HomeViewModel.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 17/10/2024.
//
import CoreLocation
import SwiftUI

@Observable @MainActor
final class HomeViewModel {
    var state: State = .loading
    var floatingErrorMessage: LocalizedStringKey?
    var errorSensoryFeedbackTrigger = false
    var successSensoryFeedbackTrigger = false
    var showAddCustomPlaceSheet = false

    private let locationService: LocationServiceProtocol

    private var remoteLocations = [Location]()
    private var customLocations = [Location]()

    enum State {
        case loading
        case data(places: [PlaceViewModel])
        case empty
        case error(message: LocalizedStringKey)

        // Convenience property to get data from state
        var data: [PlaceViewModel]? {
            guard case let .data(places) = self else {
                return nil
            }
            return places
        }
    }

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }
}

// MARK: - View events

extension HomeViewModel {
    func onTask() async {
        await getLocations()
    }

    func onRetryTap() async {
        await getLocations()
    }

    func onPlaceTap(_ place: PlaceViewModel, openURLAction: OpenURLAction) {
        openWikipediaForPlace(place, openURLAction: openURLAction)
    }

    func onAddCustomPlaceTap() {
        showAddCustomPlaceSheet = true
    }

    func onSaveCustomPlaceTap(_ newLocation: Location?) {
        defer {
            showAddCustomPlaceSheet = false
        }

        guard let location = newLocation else {
            // Field validation is done before the user has the option of even saving a location. No error handling is needed here
            return
        }

        customLocations.append(location)

        updateDataState()
    }
}

// MARK: - Private functions

private extension HomeViewModel {
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
        if remoteLocations.isEmpty, customLocations.isEmpty {
            state = .empty
        } else {
            state = .data(places: remoteLocations.map(PlaceViewModel.init) + customLocations.map(PlaceViewModel.init))
        }
    }

    func openWikipediaForPlace(_ location: PlaceViewModel, openURLAction: OpenURLAction) {
        guard let url = location.wikipediaURL else {
            showFloatingError("The location cannot opened. The location seems to have incorrect coordinates.")
            return
        }

        openURLAction.callAsFunction(url) { [weak self] accepted in
            guard accepted else {
                self?.errorSensoryFeedbackTrigger.toggle()
                self?.showFloatingError("The location cannot be opened. Make sure you have the Wikipedia app installed.")
                return
            }
            self?.successSensoryFeedbackTrigger.toggle()
        }
    }

    func showFloatingError(_ message: LocalizedStringKey) {
        withAnimation {
            floatingErrorMessage = message
        }
    }

    func showFullScreenError(_ message: LocalizedStringKey) {
        state = .error(message: message)
    }
}
