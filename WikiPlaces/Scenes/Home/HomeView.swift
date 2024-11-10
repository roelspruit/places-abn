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
                    .focusAccessibilityOnAppear()
            case .empty:
                EmptyDataView(
                    title: "No locations found. Do you want to add a custom location?",
                    buttonTitle: "Add custom location",
                    buttonAction: viewModel.onAddCustomPlaceTap
                )
                .focusAccessibilityOnAppear()
                .padding()
            case let .data(places):
                VStack(spacing: 0) {
                    ScrollView {
                        PlaceGridView(places: places, onPlaceTap: viewModel.onPlaceTap)
                            .padding()
                    }
                }
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
                .focusAccessibilityOnAppear()
                .padding()
            }
        }
        .floatingErrorMessage($viewModel.floatingErrorMessage)
        .sheet(
            isPresented: $viewModel.showAddCustomPlaceSheet,
            content: {
                NavigationStack {
                    AddPlaceView(viewModel: AddPlaceViewModel(
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    openURL(URL(string: "https://www.linkedin.com/in/roelspruit/")!)
                } label: {
                    Image("linkedin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                }
                .accessibilityLabel("Open my LinkedIn Profile")
            }

            if case .data = viewModel.state {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Location", systemImage: "plus") {
                        withAnimation {
                            viewModel.onAddCustomPlaceTap()
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.onTask()
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
