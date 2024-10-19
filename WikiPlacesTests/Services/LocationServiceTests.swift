//
//  LocationServiceTests.swift
//  WikiPlacesTests
//
//  Created by Roel Spruit on 19/10/2024.
//

import Testing
import Foundation
@testable import WikiPlaces

struct LocationServiceTests {

    @Test("Incorrect configured URL should not result in a service call") func shouldCheckForIncorrectJSONURL() async throws {
        let dataRequestService = DataRequestServiceMock(mockResponses: [:])
        let sut = LocationService(
            dataRequestService: dataRequestService,
            appConfigurationRepository: AppConfigurationRepositoryMock(
                locationJSONURLStub: { nil }
            )
        )

        await #expect(throws: LocationService.ServiceError.incorrectURLConfiguration, performing: {
            try await sut.getLocations()
        })
    }

    @Test("Request to a valid URL with valid data") func getLocationsAndDecode() async throws {
        let url = URL(string: "http://www.someurl.com")!
        let response = LocationListResponse(locations: Location.examples)
        let expectedData = try JSONEncoder().encode(response)
        let dataRequestService = DataRequestServiceMock(mockResponses: [
            url: expectedData
        ])

        let sut = LocationService(
            dataRequestService: dataRequestService,
            appConfigurationRepository: AppConfigurationRepositoryMock(
                locationJSONURLStub: { url }
            )
        )

        let result = try await sut.getLocations()

        #expect(result == response.locations)
    }

    @Test("Incorrect data format received") func getLocationsThrowsErrorOnIncorrectDecoding() async throws {

        let url = URL(string: "http://www.someurl.com")!
        let response = Location.examples // Incorrect data. Should be wrapped in a `LocationListResponse`
        let expectedData = try JSONEncoder().encode(response)
        let dataRequestService = DataRequestServiceMock(mockResponses: [
            url: expectedData
        ])

        let sut = LocationService(
            dataRequestService: dataRequestService,
            appConfigurationRepository: AppConfigurationRepositoryMock(
                locationJSONURLStub: { url }
            )
        )

        await #expect(throws: Error.self, performing: {
            _  = try await sut.getLocations()
        })
    }
}
