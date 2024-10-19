//
//  PlacesListViewModelTests.swift
//  WikiPlacesTests
//
//  Created by Roel Spruit on 19/10/2024.
//

import Testing
@testable import WikiPlaces
import SwiftUICore

struct PlacesListViewModelTests {

    // MARK: - Loading

    @Test func dataShouldLoadOnAppear() async throws {
        await confirmation { confirmation in
            let locationService = MockLocationService(getLocationsStub: {
                confirmation.confirm()
                return Location.examples
            })

            let sut = PlacesListViewModel(locationService: locationService)

            await sut.onTask()

            #expect(sut.data == Location.examples)
        }
    }

    @Test func dataShouldLoadOnRetry() async throws {
        await confirmation { confirmation in
            let locationService = MockLocationService(getLocationsStub: {
                confirmation.confirm()
                return Location.examples
            })

            let sut = PlacesListViewModel(locationService: locationService)

            await sut.onRetryTap()

            #expect(sut.data == Location.examples)
        }
    }

    // MARK: - Location Opening

    @Test func locationTapShouldOpenWikipediaURL() async throws {
        await confirmation { confirmation in
            let location = Location.examples.first!
            let sut = PlacesListViewModel(locationService: MockLocationService())
            var openedURL: URL?
            let urlAction = await OpenURLAction { url in
                openedURL = url
                confirmation.confirm()
                return .handled
            }

            sut.onLocationTap(location, openURLAction: urlAction)

            #expect(sut.floatingErrorMessage == nil)
            #expect(openedURL?.absoluteString == "wikipedia://places/?WMFCoordinate=52.3547498,4.8339215")
        }
    }

    @Test func incorrectLocationShouldShowError() async throws {
        await confirmation(expectedCount: 0) { confirmation in
            // Location with invalid GPS coordinates
            let location = Location(name: nil, latitude: -100, longitude: 200)

            let sut = PlacesListViewModel(locationService: MockLocationService())
            let urlAction = await OpenURLAction { url in
                confirmation.confirm()
                return .handled
            }

            sut.onLocationTap(location, openURLAction: urlAction)

            #expect(sut.floatingErrorMessage == "The location cannot opened due to incorrect coordinates.")
        }
    }

    @Test func failingURLActionShouldShowError() async throws {
        await confirmation { confirmation in
            let location = Location.examples.first!
            let sut = PlacesListViewModel(locationService: MockLocationService())
            let urlAction = await OpenURLAction { url in
                confirmation.confirm()
                return .discarded
            }

            sut.onLocationTap(location, openURLAction: urlAction)

            #expect(sut.floatingErrorMessage == "The location cannot be opened. Make sure you have the Wikipedia app installed.")
        }
    }

    // MARK: - Custom Location

    @Test func addCustomLocationShouldShowSheet() async throws {
        let sut = PlacesListViewModel(locationService: MockLocationService())

        sut.onAddCustomLocationTap()

        #expect(sut.showAddCustomLocationSheet)
    }

    @Test func cancelAddCustomLocationShouldHideSheet() async throws {
        let sut = PlacesListViewModel(locationService: MockLocationService())

        sut.onAddCustomLocationTap()
        sut.onCancelAddingCustomLocationTap()

        #expect(sut.showAddCustomLocationSheet == false)
    }

    @Test func dismissCustomLocationShouldClearFields() async throws {
        let sut = PlacesListViewModel(locationService: MockLocationService())
        sut.customLocationName = "Some Location Name"
        sut.customLocationLatitude = "90.0"
        sut.customLocationLongitude = "180.0"

        sut.onCustomLocationSheetDismiss()

        #expect(sut.customLocationName == "")
        #expect(sut.customLocationLatitude == "")
        #expect(sut.customLocationLongitude == "")
    }

    @Test("Invalid fields for custom locations", arguments: [
        ("", "", ""),
        ("Non-double values", "abc", "def"),
        ("Missing Longitude", "52.3547498", ""),
        ("Missing Latitude", "", "4.8339215"),
        ("Out-of-bounds latitude", "91", "4.8339215"),
        ("Out-of-bounds longitude", "52.3547498", "181")
    ])
    func invalidCustomLocationFields(name: String, latitude: String, longitude: String) {
        let sut = PlacesListViewModel(locationService: MockLocationService())
        sut.customLocationName = name
        sut.customLocationLatitude = latitude
        sut.customLocationLongitude = longitude

        #expect(sut.customLocationIsInvalid)
    }

    @Test("Valid fields for custom locations", arguments: [
        ("Valid Coordinates", "52.3547498", "4.8339215"),
        ("Valid Coordinates with comma separator", "52,3547498", "4,8339215"),
        ("", "52.3547498", "4.8339215"),
        ("Valid Coordinates", "90", "180"),
        ("Valid Coordinates", "-90", "-180")
    ])
    func validCustomLocationFields(name: String, latitude: String, longitude: String) {
        let sut = PlacesListViewModel(locationService: MockLocationService())
        sut.customLocationName = name
        sut.customLocationLatitude = latitude
        sut.customLocationLongitude = longitude

        #expect(!sut.customLocationIsInvalid)
    }

    @Test func saveCustomLocationShouldUpdateData() {
        let locationService = MockLocationService()
        let sut = PlacesListViewModel(locationService: locationService)
        sut.customLocationName = "Some Location Name"
        sut.customLocationLatitude = "90.0"
        sut.customLocationLongitude = "180.0"

        sut.onSaveCustomLocationTap()

        #expect(sut.data.count == 1)
        #expect(sut.data.first?.displayName == "Some Location Name")
        #expect(sut.data.first?.latitude == 90)
        #expect(sut.data.first?.longitude == 180)
    }
}