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
                locationGridView(locations)
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
            onDismiss: viewModel.onCustomLocationSheetDismiss,
            content: customLocationForm
        )
        .animation(.easeInOut, value: viewModel.floatingErrorMessage)
        .animation(.easeInOut, value: viewModel.showAddCustomLocationSheet)
        .navigationTitle("Locations")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onTask()
        }
    }

    private func locationGridView(_ locations: [Location]) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 20) {
                    ForEach(locations) { location in
                        LocationCardView(
                            location: location,
                            onLocationTap: viewModel.onLocationTap
                        )
                    }
                }
                .padding()
            }

            footer()
        }
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

    private func customLocationForm() -> some View {
        NavigationStack {
            AddLocationForm(
                locationName: $viewModel.customLocationName,
                latitude: $viewModel.customLocationLatitude,
                longitude: $viewModel.customLocationLongitude,
                fieldValidator: { viewModel.customLocationIsValid },
                onSaveCustomLocationTap: viewModel.onSaveCustomLocationTap,
                onCancelAddingCustomLocationTap: viewModel.onCancelAddingCustomLocationTap)
        }
        .presentationDetents([.height(250)])
    }

    private func footer() -> some View {
        VStack(spacing: 15) {
            Divider()

            Text("ABN AMRO Hiring Assignment 2024.\nCode written by Roel Spruit.")
                .font(.caption)
                .italic()
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Open my LinkedIn Profile") {
                openURL(URL(string: "https://www.linkedin.com/in/roelspruit/")!)
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
