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
    var floatingErrorMessage: String? = nil

    private let locationService: LocationServiceProtocol
    private let floatingErrorAutoHideInterval: TimeInterval = 5
    private var floatingErrorAutoHideTimer: Timer?

    enum State {
        case loading
        case data(locations: [Location])
        case error(message: String)
    }

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }

    func onTask() async {
        await getLocations()
    }

    func onRetry() {
        Task { @MainActor in
            await getLocations()
        }
    }

    func onLocationTap(_ location: Location, openURLAction: OpenURLAction) {
        guard let url = wikipediaURLForLocation(location) else {
            showFloatingError("The location cannot opened due to incorrect coordinates")
            return
        }

        openURLAction.callAsFunction(url) { [weak self] accepted in
            guard accepted else {
                self?.showFloatingError("The location cannot be opened. Make sure you have the Wikipedia app installed.")
                return
            }
        }
    }
}

private extension PlacesListViewModel {
    func getLocations() async {
        state = .loading

        do {
            let retrievedLocations: [Location] = try await locationService.getLocations()
            state = .data(locations: retrievedLocations)
        } catch {
            state = .error(message: "Error loading locations. Check your internet connection and try again")
        }
    }

    func wikipediaURLForLocation(_ location: Location) -> URL? {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        guard CLLocationCoordinate2DIsValid(coordinate) else {
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
}
