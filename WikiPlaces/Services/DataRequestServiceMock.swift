//
//  DataRequestServiceMock.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 19/10/2024.
//

import Foundation

/// Mock class used for SwiftUI previews and unit tests
struct DataRequestServiceMock: DataRequestServiceProtocol {
    let mockResponses: [URL: Data]

    func request<T>(from url: URL) async throws -> T where T: Decodable {
        let data = mockResponses[url]!
        return try JSONDecoder().decode(T.self, from: data)
    }
}
