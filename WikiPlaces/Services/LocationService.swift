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

final class MockLocationService: LocationServiceProtocol {

    private var getLocations_callBack: () async throws -> [Location]

    init(getLocations_callBack: @escaping () async throws -> [Location]) {
        self.getLocations_callBack = getLocations_callBack
    }

    func getLocations() async throws -> [Location] {
        try await getLocations_callBack()
    }
}
