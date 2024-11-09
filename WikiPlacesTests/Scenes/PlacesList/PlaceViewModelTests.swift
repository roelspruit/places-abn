//
//  PlaceViewModelTests.swift
//  WikiPlacesTests
//
//  Created by Roel Spruit on 08/11/2024.
//

import CoreLocation
import Testing

@testable import WikiPlaces

struct PlaceViewModelTests {
    @Test("Correct icon name for different types of locations", arguments: [
        (true, "person"),
        (false, "globe")
    ])
    func iconName(isUserLocation: Bool, expectedIconName: String) async throws {
        let location = Location(name: nil, latitude: .zero, longitude: .zero, isUserLocation: isUserLocation)
        let sut = PlaceViewModel(location: location)
        #expect(sut.iconName == expectedIconName)
    }

    @Test("Accessible display name for different types of locations", arguments: [
        ("", false),
        (nil, false),
        ("Some location name", true)
    ])
    func hasAccessibleDisplayName(name: String?, isAccessible: Bool) async throws {
        let location = Location(name: name, latitude: .zero, longitude: .zero)
        let sut = PlaceViewModel(location: location)
        #expect(sut.hasAccessibleDisplayName == isAccessible)
    }

    @Test("Correct display name", arguments: [
        ("", "20.0, 30.0"),
        (nil, "20.0, 30.0"),
        ("Some Location Name", "Some Location Name")
    ])
    func displayName(name: String?, expectedDisplayName: String) async throws {
        let location = Location(name: name, latitude: 20.0, longitude: 30.0)
        let sut = PlaceViewModel(location: location)
        #expect(sut.displayName == expectedDisplayName)
    }

    @Test("Correct wikipedia URL", arguments: [
        (20.0, 30.0, "wikipedia://places/?WMFCoordinate=20.0,30.0"),
        (-200, -300, nil),
    ])
    func wikipediaURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees, expectedURL: String?) async throws {
        let location = Location(name: "Some Location Name", latitude: latitude, longitude: longitude)
        let sut = PlaceViewModel(location: location)
        #expect(sut.wikipediaURL?.absoluteString == expectedURL)
    }

    @Test("Correct id", arguments: [
        ("", "20.030.0"),
        ("Some Name", "Some Name20.030.0")
    ])
    func wikipediaURL(name: String?, expectedID: String) async throws {
        let location = Location(name: name, latitude: 20.0, longitude: 30.0)
        let sut = PlaceViewModel(location: location)
        #expect(sut.id == expectedID)
    }
}
