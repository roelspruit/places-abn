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

    private let appConfigurationRepository: AppConfigurationRepositoryProtocol

    enum LocationServiceError: Error {
        case incorrectURLConfiguration
    }

    init(appConfigurationRepository: AppConfigurationRepositoryProtocol) {
        self.appConfigurationRepository = appConfigurationRepository
    }

    func getLocations() async throws -> [Location] {

        guard let url = appConfigurationRepository.locationJSONURL else {
            throw LocationServiceError.incorrectURLConfiguration
        }

        let response: LocationListResponse = try await URLSession.shared.decode(from: url)

        return response.locations
    }
}

/// An implementation of LocationServiceProtocol that can be used to provide fake data in SwiftUI previews or Unit Tests
final class MockLocationService: LocationServiceProtocol {

    var getLocationsStub: () async throws -> [Location]

    init(
        getLocationsStub: @escaping () async throws -> [Location] = { [] }
    ) {
        self.getLocationsStub = getLocationsStub
    }

    func getLocations() async throws -> [Location] {
        try await getLocationsStub()
    }
}
