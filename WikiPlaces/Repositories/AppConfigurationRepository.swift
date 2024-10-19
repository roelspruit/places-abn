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

final class AppConfigurationRepository: AppConfigurationRepositoryProtocol {

    private enum InfoDictionaryKey: String {
        case locationJSONURL = "LOCATION_JSON_URL"
    }

    var locationJSONURL: URL? {
        getURLDictionaryValue(withKey: .locationJSONURL)
    }

    private func getURLDictionaryValue(withKey key: InfoDictionaryKey) -> URL? {
        guard let urlString = getStringDictionaryValue(withKey: key) else { return nil }
        return URL(string: urlString)
    }

    private func getStringDictionaryValue(withKey key: InfoDictionaryKey) -> String? {
        Bundle.main.infoDictionary?[key.rawValue] as? String
    }
}

final class MockAppConfigurationRepository: AppConfigurationRepositoryProtocol {

    private var locationJSONURLStub: () -> URL?

    init(locationJSONURLStub: @escaping () -> URL?) {
        self.locationJSONURLStub = locationJSONURLStub
    }

    var locationJSONURL: URL? {
        locationJSONURLStub()
    }
}
