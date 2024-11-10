//
//  PlaceViewModel.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 08/11/2024.
//

import CoreLocation
import Foundation

struct PlaceViewModel {
    private let location: Location

    init(location: Location) {
        self.location = location
    }

    var iconName: String {
        location.isUserLocation ? "person" : "globe"
    }

    /// If the location has no name and only GPS coordinate we would rather not read out these coordinates as the location's name
    var hasAccessibleDisplayName: Bool {
        location.name?.isEmpty == false
    }

    var isUserLocation: Bool {
        location.isUserLocation
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }

    var displayName: String {
        if let locationName = location.name, !locationName.isEmpty {
            locationName
        } else {
            "\(location.latitude), \(location.longitude)"
        }
    }

    var hasValidCoordinate: Bool {
        coordinate.isValidCoordinate
    }

    var wikipediaURL: URL? {
        guard hasValidCoordinate else {
            return nil
        }

        return URL(string: "wikipedia://places/?WMFCoordinate=\(location.latitude),\(location.longitude)")
    }
}

extension PlaceViewModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension PlaceViewModel: Identifiable {
    var id: String {
        "\(location.name ?? "")\(location.latitude)\(location.longitude)"
    }
}
