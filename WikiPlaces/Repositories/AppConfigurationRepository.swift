//
//  AppConfiguration.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 17/10/2024.
//

import Foundation

protocol AppConfigurationRepositoryProtocol {
    var locationJSONURL: URL? { get }
}

/// Provides strongly typed access to information from the app bundle's `infoDictionary`
final class AppConfigurationRepository: AppConfigurationRepositoryProtocol {

    private enum InfoDictionaryKey: String {
        case locationJSONURL = "LOCATION_JSON_URL"
    }

    var locationJSONURL: URL? {
        getURLDictionaryValue(withKey: .locationJSONURL)
    }
}

// MARK: - InfoDictionary access

private extension AppConfigurationRepository {
    private func getURLDictionaryValue(withKey key: InfoDictionaryKey) -> URL? {
        guard let urlString = getStringDictionaryValue(withKey: key) else { return nil }
        return URL(string: urlString)
    }

    private func getStringDictionaryValue(withKey key: InfoDictionaryKey) -> String? {
        Bundle.main.infoDictionary?[key.rawValue] as? String
    }
}
