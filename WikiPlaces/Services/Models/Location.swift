//
//  Location.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 16/10/2024.
//

import CoreLocation

struct Location: Codable {

    let name: String?
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    // For convenience this information is stored in the model
    // For decoded JSON data this is `false` by default. For user-created locations it is set to `true`
    var isUserLocation: Bool = false

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}

extension Location: Equatable {
    // Excludes `isUserLocation` from equality comparison since it is irrelevant
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
        && lhs.name == rhs.name
    }
}

extension Location: Identifiable {
    var id: String {
        "\(name ?? "")\(latitude)\(longitude)"
    }
}

extension Location {

    var displayName: String {
        name ?? "\(latitude), \(longitude)"
    }

    var hasValidCoordinate: Bool {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return CLLocationCoordinate2DIsValid(coordinate)
    }

    static let examples: [Location] = [
        .init(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
        .init(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785),
        .init(name: "ABN AMRO", latitude: 52.3373763, longitude: 4.8723054),
        .init(name: "Brussels", latitude: 55.6713442, longitude: 12.523785, isUserLocation: true),
        .init(name: "Leiden", latitude: 55.6713442, longitude: 12.523785, isUserLocation: true)
    ]
}
