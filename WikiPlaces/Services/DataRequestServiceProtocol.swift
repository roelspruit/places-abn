//
//  DataRequestServiceProtocol.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 19/10/2024.
//

import Foundation

protocol DataRequestServiceProtocol: Sendable {
    func request<T>(from url: URL) async throws -> T where T: Decodable
}

extension URLSession: DataRequestServiceProtocol {
    func request<T>(from url: URL) async throws -> T where T: Decodable {
        let (data, _) = try await data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
