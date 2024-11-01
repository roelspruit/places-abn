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
    var floatingErrorMessage: String?

    // Convenience property to get data from state in unit tests
    var data: [Location] {
        guard case .data(let locations) = state else {
            return []
        }
        return locations
    }

    var showAddCustomLocationSheet = false
    var customLocationName: String = ""
    var customLocationLatitude: String = ""
    var customLocationLongitude: String = ""

    var customLocationIsInvalid: Bool {
        locationFromCustomLocationFields == nil
    }

    var hasEnteredCustomLocationFields: Bool {
        !customLocationLatitude.isEmpty && !customLocationLongitude.isEmpty
    }

    private let locationService: LocationServiceProtocol
    private let floatingErrorAutoHideInterval: TimeInterval = 5
    private var floatingErrorAutoHideTimer: Timer?

    private var remoteLocations = [Location]()
    private var customLocations = [Location]()

    enum State {
        case loading
        case data(locations: [Location])
        case empty
        case error(message: String)
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

    func onSaveCustomLocationTap() {

        guard let location = locationFromCustomLocationFields else {
            // Field validation is done before the user has the option of even saving a location. No error handling is needed here
            return
        }

        customLocations.append(location)

        updateDataState()

        clearCustomLocationData()
        showAddCustomLocationSheet = false
    }

    func onCancelAddingCustomLocationTap() {
        showAddCustomLocationSheet = false
    }

    func onCustomLocationSheetDismiss() {
        clearCustomLocationData()
    }
}

// MARK: - Private functions and properties

private extension PlacesListViewModel {

    var locationFromCustomLocationFields: Location? {
        // Slightly hacky: the `decimalPad` keyboard type uses comma as a separator, the Double type requires a dot separator
        guard let latitude = customLocationLatitude.doubleValue,
              let longitude = customLocationLongitude.doubleValue else {
            return nil
        }

        let location = Location(
            name: customLocationName.isEmpty ? nil : customLocationName,
            latitude: latitude,
            longitude: longitude,
            isUserLocation: true
        )

        guard location.hasValidCoordinate else {
            return nil
        }

        return location
    }

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

    func showFloatingError(_ message: String) {

        floatingErrorAutoHideTimer?.invalidate()

        floatingErrorMessage = message
        floatingErrorAutoHideTimer = Timer.scheduledTimer(withTimeInterval: floatingErrorAutoHideInterval, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.floatingErrorMessage = nil
                self?.floatingErrorAutoHideTimer = nil
            }
        }
    }

    func showFullScreenError(_ message: String) {
        state = .error(message: message)
    }

    func clearCustomLocationData() {
        customLocationName = ""
        customLocationLatitude = ""
        customLocationLongitude = ""
    }
}

private extension String {
    var doubleValue: Double? {
        let sanitizedString = self
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return Double(sanitizedString)
    }
}
