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
                LoadingView(title: "Loading locations")
            case .empty:
                EmptyDataView(
                    title: "No locations found. Do you want to add a custom location?",
                    buttonTitle: "Add custom location",
                    buttonAction: viewModel.onAddCustomLocationTap
                )
            case .data(let locations):
                placeGridView(locations)
            case .error(let message):
                FullscreenErrorView(
                    title: message,
                    buttonTitle: "Retry",
                    buttonAction: {
                        Task {
                            await viewModel.onRetryTap()
                        }
                    }
                )
            }
        }
        .overlay(
            alignment: .bottom,
            content: { FloatingErrorView(message: $viewModel.floatingErrorMessage) }
        )
        .sheet(
            isPresented: $viewModel.showAddCustomLocationSheet,
            content: {
                NavigationStack {
                    AddPlaceForm(viewModel: AddPlaceFormViewModel(
                        onSaveLocation: viewModel.onSaveCustomLocationTap
                    ))
                }
                .presentationDetents([.medium])
            }
        )
        .animation(.easeInOut, value: viewModel.floatingErrorMessage)
        .animation(.easeInOut, value: viewModel.showAddCustomLocationSheet)
        .navigationTitle("Locations")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onTask()
        }
    }

    private func placeGridView(_ locations: [PlaceViewModel]) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 20) {
                    ForEach(locations) { location in
                        PlaceCardView(
                            place: location,
                            onPlaceTap: viewModel.onPlaceTap
                        )
                    }
                }
                .padding()
            }

            footerView
        }
        .sensoryFeedback(.error, trigger: viewModel.errorSensoryFeedbackTrigger)
        .sensoryFeedback(.success, trigger: viewModel.successSensoryFeedbackTrigger)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Location", systemImage: "plus") {
                    withAnimation {
                        viewModel.onAddCustomLocationTap()
                    }
                }
            }
        }
    }

    private var footerView: some View {
        VStack(spacing: 5) {
            Divider()

            Text("ABN AMRO Hiring Assignment 2024 by Roel Spruit.")
                .font(.caption)
                .italic()
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 5)

            Button {
                openURL(URL(string: "https://www.linkedin.com/in/roelspruit/")!)
            } label: {
                Text("Open my LinkedIn Profile")
                    .font(.caption)
            }
        }

        .accessibilityHidden(true)
        .background(Color.cardBackground.shadow(.drop(color: .black.opacity(0.1), radius: 3)))
    }
}

#Preview("Content") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: LocationServiceMock()
            )
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: LocationServiceMock(getLocationsStub: {
                    return []
                })
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: LocationServiceMock(getLocationsStub: {
                    throw LocationService.ServiceError.incorrectURLConfiguration
                })
            )
        )
    }
}

// Slight exception in showing this specific preview because we want to modify the state of the sheet in the viewmodel
struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PlacesListViewModel(
            locationService: LocationServiceMock()
        )
        viewModel.showAddCustomLocationSheet = true
        return NavigationStack {
            PlacesListView(
                viewModel: viewModel
            )
        }
        .previewDisplayName("Add Location")
    }
}
