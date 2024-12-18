//
//  HomeViewModelTests.swift
//  WikiPlacesTests
//
//  Created by Roel Spruit on 19/10/2024.
//

import SwiftUICore
import Testing
@testable import WikiPlaces

@MainActor struct HomeViewModelTests {
    // MARK: - Loading

    enum TestingError: Error {
        case dataUnwrapError
    }

    @Test("Location service should be called when view appears")
    func dataShouldLoadOnAppear() async throws {
        let locationService = LocationServiceMock()
        let sut = HomeViewModel(locationService: locationService)

        await sut.onTask()

        let data = try #require(sut.state.data)
        #expect(data == Location.examples.map(PlaceViewModel.init))
    }

    @Test("Location service should be called when tapping retry button")
    func dataShouldLoadOnRetry() async throws {
        let locationService = LocationServiceMock()
        let sut = HomeViewModel(locationService: locationService)

        await sut.onRetryTap()

        let data = try #require(sut.state.data)
        #expect(data == Location.examples.map(PlaceViewModel.init))
    }

    // MARK: - Location Opening

    @Test("Tapping a location should open the wikipedia app")
    func locationTapShouldOpenWikipediaURL() async throws {
        let place = PlaceViewModel(location: Location.examples.first!)
        let sut = HomeViewModel(locationService: LocationServiceMock())
        var openedURL: URL?
        let urlAction = OpenURLAction { url in
            openedURL = url
            return .handled
        }

        sut.onPlaceTap(place, openURLAction: urlAction)

        #expect(sut.floatingErrorMessage == nil)
        #expect(openedURL?.absoluteString == "wikipedia://places/?WMFCoordinate=52.3547498,4.8339215")
    }

    @Test("Tapping location with incorrect coordinates should show an error")
    func incorrectLocationShouldShowError() async throws {
        // Location with invalid GPS coordinates
        let place = PlaceViewModel(location: Location(name: nil, latitude: -100, longitude: 200))
        let sut = HomeViewModel(locationService: LocationServiceMock())
        let urlAction = OpenURLAction { _ in
            .handled
        }

        sut.onPlaceTap(place, openURLAction: urlAction)

        #expect(sut.floatingErrorMessage == "The location cannot opened. The location seems to have incorrect coordinates.")
    }

    @Test("Failure to open wikipedia app should show an error")
    func failingURLActionShouldShowError() async throws {
        let place = PlaceViewModel(location: Location.examples.first!)
        let sut = HomeViewModel(locationService: LocationServiceMock())
        let urlAction = OpenURLAction { _ in
            .discarded
        }

        sut.onPlaceTap(place, openURLAction: urlAction)

        #expect(sut.floatingErrorMessage == "The location cannot be opened. Make sure you have the Wikipedia app installed.")
    }

    // MARK: - Custom Location

    @Test("Show custom location sheet")
    func addCustomLocationShouldShowSheet() async throws {
        let sut = HomeViewModel(locationService: LocationServiceMock())

        sut.onAddCustomPlaceTap()

        #expect(sut.showAddCustomPlaceSheet)
    }

    @Test("Save custom location sheet should hide sheet")
    func cancelAddCustomLocationShouldHideSheet() async throws {
        let sut = HomeViewModel(locationService: LocationServiceMock())

        sut.onSaveCustomPlaceTap(.examples.first!)

        #expect(sut.showAddCustomPlaceSheet == false)
    }
}
