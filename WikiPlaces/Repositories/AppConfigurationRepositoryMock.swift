//
//  AppConfigurationRepositoryMock.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 19/10/2024.
//

import Foundation

/// Mock class used for SwiftUI previews and unit tests
actor AppConfigurationRepositoryMock: AppConfigurationRepositoryProtocol {

    private let locationJSONURLStub: @Sendable () -> URL?

    init(locationJSONURLStub: @Sendable @escaping () -> URL?) {
        self.locationJSONURLStub = locationJSONURLStub
    }

    var locationJSONURL: URL? {
        locationJSONURLStub()
    }
}
