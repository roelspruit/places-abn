//
//  URLSessionProtocol.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 19/10/2024.
//
import Foundation

protocol DataRequestServiceProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: DataRequestServiceProtocol { }

extension DataRequestServiceProtocol {
    func request<T>(from url: URL) async throws -> T where T: Decodable {
        let (data, _) = try await data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct MockURLSession: DataRequestServiceProtocol {
    let mockResponses: [URL: Data]

    func data(from url: URL) async throws -> (Data, URLResponse) {
        // Force unwrapping here on purpose to make sure testcases crash on unmocked URLs
        (mockResponses[url]!, URLResponse())
    }
}
