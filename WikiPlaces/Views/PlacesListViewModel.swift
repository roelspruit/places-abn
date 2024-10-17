//
//  PlacesListViewModel.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 17/10/2024.
//
import SwiftUI

@Observable
class PlacesListViewModel {

    var state: State = .loading

    private let locationService: LocationServiceProtocol

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
            // TODO: show error
            return
        }

        openURLAction.callAsFunction(url) { accepted in
            if accepted {
                return
            }
            // TODO: show error
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
            state = .error(message: "Error loading places. Check your internet connection and try again")
        }
    }

    func wikipediaURLForLocation(_ location: Location) -> URL? {
        URL(string: "wikipedia://en.wikipedia.org/wiki/Red")
    }
}
