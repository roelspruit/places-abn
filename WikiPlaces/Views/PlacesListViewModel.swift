//
//  PlacesListViewModel.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 17/10/2024.
//
import SwiftUI
import CoreLocation

@Observable
class PlacesListViewModel {

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

    func onTask() async {
        await getLocations()
    }

    func onRetryTap() async {
        await getLocations()
    }

    func onLocationTap(_ location: Location, openURLAction: OpenURLAction) {
        openlocation(location, openURLAction: openURLAction)
    }

    func onAddCustomLocationTap() {
        showAddCustomLocationSheet = true
    }

    var customLocationIsInvalid: Bool {
        locationFromCustomLocationFields == nil
    }

    var hasEnteredCustomLocationFields: Bool {
        !customLocationLatitude.isEmpty && !customLocationLongitude.isEmpty
    }

    func onSaveCustomLocationTap(openURLAction: OpenURLAction) {

        guard let location = locationFromCustomLocationFields else {
            // Field validation is done before the user has the option of even saving a location. No error handling is needed here
            return
        }

        customLocations.append(location)

        updateDataState()

        clearCustomLocationData()
        showAddCustomLocationSheet = false

        openlocation(location, openURLAction: openURLAction)
    }

    func onCancelAddingCustomLocationTap() {
        showAddCustomLocationSheet = false
    }

    func onCustomLocationSheetDismiss() {
        clearCustomLocationData()
    }
}

private extension PlacesListViewModel {

    var locationFromCustomLocationFields: Location? {
        guard let latitude = Double(customLocationLatitude.replacingOccurrences(of: ",", with: ".")), let longitude = Double(customLocationLongitude.replacingOccurrences(of: ",", with: ".")) else {
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
            state = .error(message: "Error loading locations. Check your internet connection and try again")
        }
    }

    func updateDataState() {
        if remoteLocations.isEmpty && customLocations.isEmpty {
            state = .empty
        } else {
            state = .data(locations: remoteLocations + customLocations)
        }
    }

    func openlocation(_ location: Location, openURLAction: OpenURLAction) {
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
            self?.floatingErrorMessage = nil
            self?.floatingErrorAutoHideTimer = nil
        }
    }

    func clearCustomLocationData() {
        customLocationName = ""
        customLocationLatitude = ""
        customLocationLongitude = ""
    }
}
