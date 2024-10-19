//
//  AppConfigurationRepositoryMock.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 19/10/2024.
//

import Foundation

/// Mock class used for SwiftUI previews and unit tests
final class AppConfigurationRepositoryMock: AppConfigurationRepositoryProtocol {

    private var locationJSONURLStub: () -> URL?

    init(locationJSONURLStub: @escaping () -> URL?) {
        self.locationJSONURLStub = locationJSONURLStub
    }

    var locationJSONURL: URL? {
        locationJSONURLStub()
    }
}
