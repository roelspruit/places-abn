//
//  LocationService.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 16/10/2024.
//

import CoreLocation

protocol LocationServiceProtocol: Sendable {
    func getLocations() async throws -> [Location]
}

/// Executes network calls to retrieve location data from a remote JSON file
final class LocationService: LocationServiceProtocol {

    private let dataRequestService: DataRequestServiceProtocol
    private let appConfigurationRepository: AppConfigurationRepositoryProtocol

    enum ServiceError: Error {
        case incorrectURLConfiguration
    }

    init(
        dataRequestService: DataRequestServiceProtocol,
        appConfigurationRepository: AppConfigurationRepositoryProtocol
    ) {
        self.dataRequestService = dataRequestService
        self.appConfigurationRepository = appConfigurationRepository
    }

    func getLocations() async throws -> [Location] {

        guard let url = appConfigurationRepository.locationJSONURL else {
            throw ServiceError.incorrectURLConfiguration
        }

        let response: LocationListResponse = try await dataRequestService.request(from: url)

        return response.locations
    }
}
