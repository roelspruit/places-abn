//
//  WikiPlacesApp.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 16/10/2024.
//

import SwiftUI

@main
struct WikiPlacesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(
                    viewModel: .init(locationService: LocationService(
                        dataRequestService: URLSession.shared,
                        appConfigurationRepository: AppConfigurationRepository()
                    ))
                )
            }
        }
    }
}
