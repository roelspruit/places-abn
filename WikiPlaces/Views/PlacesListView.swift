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
            case .empty:
                emptyDataView()
            case .data(let locations):
                locationListView(locations)
            case .error(let message):
                errorView(message)
            }
        }
        .overlay(
            alignment: .bottom,
            content: floatingErrorMessageView
        )
        .sheet(
            isPresented: $viewModel.showAddCustomLocationSheet,
            onDismiss: viewModel.onCustomLocationSheetDismiss,
            content: addCustomLocationSheet
        )
        .animation(.easeInOut, value: viewModel.floatingErrorMessage)
        .animation(.easeInOut, value: viewModel.showAddCustomLocationSheet)
        .navigationTitle("Locations")
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
                    Label(location.displayName, systemImage: location.isUserLocation ? "person" : "globe")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.primary)
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

    private func loadingView() -> some View {
        ProgressView("Loading locations")
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

            Button("Retry",
                   action: {
                Task { await viewModel.onRetryTap() }
            })
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    @ViewBuilder private func floatingErrorMessageView() -> some View {
        if let floatingErrorMessage = viewModel.floatingErrorMessage {
            VStack(alignment: .leading) {
                Text(floatingErrorMessage)
                    .foregroundStyle(.white)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .background(Color("ABNGreen"))
            .onTapGesture {
                viewModel.floatingErrorMessage = nil
            }
        }
    }

    private func emptyDataView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100)

            Text("No locations found. Do you want to add a custom location?")
                .multilineTextAlignment(.center)

            Button("Add custom location", action: viewModel.onAddCustomLocationTap)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private func addCustomLocationSheet() -> some View {
        NavigationStack {
            Form {
                TextField("Name", text: $viewModel.customLocationName)
                    .clearButton(text: $viewModel.customLocationName)
                TextField("Latitude", text: $viewModel.customLocationLatitude, axis: .vertical)
                    .keyboardType(.decimalPad)
                    .clearButton(text: $viewModel.customLocationLatitude)
                TextField("Longitude", text: $viewModel.customLocationLongitude, axis: .vertical)
                    .keyboardType(.decimalPad)
                    .clearButton(text: $viewModel.customLocationLatitude)
            }
            .autocorrectionDisabled()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.onSaveCustomLocationTap()
                    }
                    .disabled(viewModel.customLocationIsInvalid)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        viewModel.onCancelAddingCustomLocationTap()
                    }
                }
            }
            .navigationTitle("Add Location")
            .navigationBarTitleDisplayMode(.inline)

        }
        .presentationDetents([.height(250)])
    }
}

#Preview("Content") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: MockLocationService(getLocationsStub: {
                    return Location.examples
                })
            )
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: MockLocationService(getLocationsStub: {
                    while(true){}
                    return []
                })
            )
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        PlacesListView(
            viewModel: .init(
                locationService: MockLocationService(getLocationsStub: {
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
                locationService: MockLocationService(getLocationsStub: {
                    throw LocationService.LocationServiceError.incorrectURLConfiguration
                })
            )
        )
    }
}

#Preview("Add Location") {
    let viewModel = PlacesListViewModel(
        locationService: MockLocationService(getLocationsStub: {
            throw LocationService.LocationServiceError.incorrectURLConfiguration
        })
    )
    viewModel.showAddCustomLocationSheet = true
    return NavigationStack {
        PlacesListView(
            viewModel: viewModel
        )
    }
}
