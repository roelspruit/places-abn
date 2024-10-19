//
//  LocationServiceMock.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 19/10/2024.
//

/// Mock class used for SwiftUI previews and unit tests
final class LocationServiceMock: LocationServiceProtocol {

    private var getLocationsStub: () async throws -> [Location]

    init(
        getLocationsStub: @escaping () async throws -> [Location] = { [] }
    ) {
        self.getLocationsStub = getLocationsStub
    }

    func getLocations() async throws -> [Location] {
        try await getLocationsStub()
    }
}
