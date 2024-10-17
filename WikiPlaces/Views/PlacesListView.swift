//
//  PlacesListView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 16/10/2024.
//

import SwiftUI

struct PlacesListView: View {

    @State var viewModel: PlacesListViewModel
    @Environment(\.openURL) var openURL

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingView()
            case .data(let locations):
                locationListView(locations)
            case .error(let message):
                errorView(message)
            }
        }
        .navigationTitle("Places")
        .task {
            await viewModel.onTask()
        }
    }

    private func locationListView(_ locations: [Location]) -> some View {
        List(locations) { location in
            Button(action: {
                viewModel.onLocationTap(location, openURLAction: openURL)
            }) {
                HStack {
                    Label(location.displayName, systemImage: "location")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
        }
    }

    private func loadingView() -> some View {
        ProgressView("Loading places")
            .controlSize(.extraLarge)
            .padding()
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100)

            Text(message)
                .multilineTextAlignment(.center)

            Button("Retry", action: viewModel.onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview("Content") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: PreviewLocationService(locations: Location.examples)
            )
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: PreviewLocationService(finishes: false)
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: PreviewLocationService(error: .incorrectURLConfiguration)
            )
        )
    }
}
