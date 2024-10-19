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

    @Test func shouldCheckForIncorrectJSONURL() async throws {
        let urlSession = MockURLSession(mockResponses: [:])
        let sut = LocationService(
            urlSession: urlSession,
            appConfigurationRepository: MockAppConfigurationRepository(
                locationJSONURLStub: { nil }
            )
        )

        await #expect(throws: LocationService.ServiceError.incorrectURLConfiguration, performing: {
            try await sut.getLocations()
        })
    }

    @Test func getLocationsAndDecode() async throws {
        let url = URL(string: "http://www.someurl.com")!
        let response = LocationListResponse(locations: Location.examples)
        let expectedData = try JSONEncoder().encode(response)
        let urlSession = MockURLSession(mockResponses: [
            url: expectedData
        ])

        let sut = LocationService(
            urlSession: urlSession,
            appConfigurationRepository: MockAppConfigurationRepository(
                locationJSONURLStub: { url }
            )
        )

        let result = try await sut.getLocations()

        #expect(result == Location.examples)
    }

    @Test func getLocationsThrowsErrorOnIncorrectDecoding() async throws {

        let url = URL(string: "http://www.someurl.com")!
        let response = Location.examples // Incorrect data. Should be wrapped in a `LocationListResponse`
        let expectedData = try JSONEncoder().encode(response)
        let urlSession = MockURLSession(mockResponses: [
            url: expectedData
        ])

        let sut = LocationService(
            urlSession: urlSession,
            appConfigurationRepository: MockAppConfigurationRepository(
                locationJSONURLStub: { url }
            )
        )

        await #expect(throws: Error.self, performing: {
            _  = try await sut.getLocations()
        })
    }
}
