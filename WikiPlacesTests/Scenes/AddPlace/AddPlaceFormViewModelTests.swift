//
//  AddPlaceFormViewModelTests.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//

import Testing
@testable import WikiPlaces
import SwiftUICore

@MainActor struct AddPlaceFormViewModelTests {

    @Test("Invalid fields for custom locations", arguments: [
        ("", "", ""),
        ("Non-double values", "abc", "def"),
        ("Missing Longitude", "52.3547498", ""),
        ("Missing Latitude", "", "4.8339215"),
        ("Out-of-bounds latitude", "91", "4.8339215"),
        ("Out-of-bounds longitude", "52.3547498", "181")
    ])
    func invalidCustomLocationFields(name: String, latitude: String, longitude: String) {
        let sut = AddPlaceFormViewModel(onSaveLocation: { _ in })
        sut.locationName = name
        sut.latitude = latitude
        sut.longitude = longitude

        #expect(!sut.saveButtonIsEnabled)
    }

    @Test("Valid fields for custom locations", arguments: [
        ("Valid Coordinates", "52.3547498", "4.8339215"),
        ("Valid Coordinates with comma separator", "52,3547498", "4,8339215"),
        ("", "52.3547498", "4.8339215"),
        ("Valid Coordinates", "90", "180"),
        ("Valid Coordinates", "-90", "-180")
    ])
    func validCustomLocationFields(name: String, latitude: String, longitude: String) {
        let sut = AddPlaceFormViewModel(onSaveLocation: { _ in })
        sut.locationName = name
        sut.latitude = latitude
        sut.longitude = longitude

        #expect(sut.saveButtonIsEnabled)
    }

    @Test("Input error shown at correct time", arguments: [
        ("Latitude too high", "200", ""),
        ("Longitude too high", "", "200"),
        ("Latitude and Longitude too high", "200", "200")
    ])
    func inputErrorShown(name: String, latitude: String, longitude: String) {
        let sut = AddPlaceFormViewModel(onSaveLocation: { _ in })
        sut.locationName = name
        sut.latitude = latitude
        sut.longitude = longitude

        #expect(sut.inputErrorIsShown)
    }

    @Test("Input error not shown for correct fields", arguments: [
        ("Not shown for empty fields", "", ""),
        ("Valid fields", "50", "50")
    ])
    func inputErrorNotShown(name: String, latitude: String, longitude: String) {
        let sut = AddPlaceFormViewModel(onSaveLocation: { _ in })
        sut.locationName = name
        sut.latitude = latitude
        sut.longitude = longitude

        #expect(!sut.inputErrorIsShown)
    }

    @Test("Saving location should return location")
    func saveCustomLocationShouldUpdateData() async throws {
        var savedLocation: Location?
        let sut = AddPlaceFormViewModel(
            onSaveLocation: { savedLocation = $0 }
        )
        sut.locationName = "Some Location Name"
        sut.latitude = "90.0"
        sut.longitude = "180.0"

        sut.onSave()

        try #require(savedLocation != nil)
        #expect(savedLocation?.name == "Some Location Name")
        #expect(savedLocation?.latitude == 90)
        #expect(savedLocation?.longitude == 180)
    }
}
