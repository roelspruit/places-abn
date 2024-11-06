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
                locationListView(locations)
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

    private func locationListView(_ locations: [Location]) -> some View {
        List(locations) { location in
            Button(action: {
                viewModel.onLocationTap(location, openURLAction: openURL)
            }, label: {
                HStack {
                    Label(location.displayName, systemImage: location.isUserLocation ? "person" : "globe")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            })
            .foregroundStyle(.primary)
        }
        .foregroundStyle(Color.abnGreen)
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Location", systemImage: "plus") {
                    withAnimation {
                        viewModel.onAddCustomLocationTap()
                    }
                }
            }
        }
        .overlay(
            alignment: .bottom,
            content: {
                Text("ABN AMRO Hiring Assignment 2024.\nCode by Roel Spruit.")
                    .padding(.horizontal, 50)
                    .font(.caption)
                    .italic()
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            })
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
}

#Preview("Content") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: LocationServiceMock(getLocationsStub: {
                    return Location.examples
                })
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
            locationService: LocationServiceMock(getLocationsStub: {
                return Location.examples
            })
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
