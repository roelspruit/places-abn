//
//  LocationService.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 16/10/2024.
//

import CoreLocation

protocol LocationServiceProtocol {
    func getLocations() async throws -> [Location]
}

final class LocationService: LocationServiceProtocol {

    enum LocationServiceError: Error {
        case incorrectURLConfiguration
    }

    func getLocations() async throws -> [Location] {
        guard let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json") else {
            throw LocationServiceError.incorrectURLConfiguration
        }

        let response: LocationListResponse = try await URLSession.shared.decode(from: url)

        return response.locations
    }
}

struct PreviewLocationService: LocationServiceProtocol {
    var locations: [Location] = []
    var error: LocationService.LocationServiceError? = nil
    var finishes = true

    func getLocations() async throws -> [Location] {
        guard finishes else {
            while(true){}
        }
        
        if let error {
            throw error
        }

        return locations
    }
}
