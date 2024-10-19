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

    func data(from url: URL) async throws -> (Data, URLResponse) {
        // Force unwrapping here on purpose to make sure testcases crash on unmocked URLs
        (mockResponses[url]!, URLResponse())
    }
}
