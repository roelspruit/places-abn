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
    var isUserLocation: Bool = false

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}

extension Location: Equatable { }

extension Location: Identifiable {

    var id: String {
        "\(name ?? "")\(latitude)\(longitude)"
    }

    var displayName: String {
        name ?? "\(latitude), \(longitude)"
    }

    var hasValidCoordinate: Bool {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return CLLocationCoordinate2DIsValid(coordinate)
    }

    static var examples: [Location] = [
        .init(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
        .init(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
    ]
}
