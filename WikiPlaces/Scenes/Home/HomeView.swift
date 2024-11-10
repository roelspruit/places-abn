//
//  HomeView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 16/10/2024.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel
    @Environment(\.openURL) var openURL

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                LoadingView(title: "Loading locations")
            case .empty:
                EmptyDataView(
                    title: "No locations found. Do you want to add a custom location?",
                    buttonTitle: "Add custom location",
                    buttonAction: viewModel.onAddCustomPlaceTap
                )
                .padding()
            case let .data(places):
                placeGridView(places)
            case let .error(message):
                FullscreenErrorView(
                    title: message,
                    buttonTitle: "Retry",
                    buttonAction: {
                        Task {
                            await viewModel.onRetryTap()
                        }
                    }
                )
                .padding()
            }
        }
        .floatingErrorMessage($viewModel.floatingErrorMessage)
        .sheet(
            isPresented: $viewModel.showAddCustomPlaceSheet,
            content: {
                NavigationStack {
                    AddPlaceForm(viewModel: AddPlaceFormViewModel(
                        onSaveLocation: viewModel.onSaveCustomPlaceTap
                    ))
                }
                .presentationDetents([.medium])
            }
        )
        .animation(.easeInOut, value: viewModel.floatingErrorMessage)
        .animation(.easeInOut, value: viewModel.showAddCustomPlaceSheet)
        .sensoryFeedback(.error, trigger: viewModel.errorSensoryFeedbackTrigger)
        .sensoryFeedback(.success, trigger: viewModel.successSensoryFeedbackTrigger)
        .navigationTitle("Locations")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onTask()
        }
    }

    private func placeGridView(_ places: [PlaceViewModel]) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                PlaceGridView(places: places, onPlaceTap: viewModel.onPlaceTap)
                    .padding()
            }

            CreditFooterView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Location", systemImage: "plus") {
                    withAnimation {
                        viewModel.onAddCustomPlaceTap()
                    }
                }
            }
        }
    }
}

#Preview("Content") {
    NavigationStack {
        HomeView(
            viewModel: .init(
                locationService: LocationServiceMock()
            )
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        HomeView(
            viewModel: .init(
                locationService: LocationServiceMock(getLocationsStub: {
                    []
                })
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        HomeView(
            viewModel: .init(
                locationService: LocationServiceMock(getLocationsStub: {
                    throw LocationService.ServiceError.incorrectURLConfiguration
                })
            )
        )
    }
}

// Slight exception in showing this specific preview because we want to modify the state of the sheet in the viewmodel
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(
            locationService: LocationServiceMock()
        )
        viewModel.showAddCustomPlaceSheet = true
        return NavigationStack {
            HomeView(
                viewModel: viewModel
            )
        }
        .previewDisplayName("Add Location")
    }
}
