//
//  AddPlaceForm.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct AddPlaceForm: View {

    @State var viewModel: AddPlaceFormViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section(content: {
                TextField("Location Name (optional)", text: $viewModel.locationName)
                    .clearButton(text: $viewModel.locationName)
                TextField("Latitude (between -90.0 and 90.0)", text: $viewModel.latitude, axis: .vertical)
                    .accessibilityHint("Value should be between -90.0 and 90.0")
                    .keyboardType(.decimalPad)
                    .clearButton(text: $viewModel.latitude)
                TextField("Longitude (between -180.0 and 180)", text: $viewModel.longitude, axis: .vertical)
                    .accessibilityHint("Value should be between -180.0 and 180.0")
                    .keyboardType(.decimalPad)
                    .clearButton(text: $viewModel.longitude)
            }, footer: {
                if viewModel.hasEnteredLocationFields && !viewModel.customLocationIsValid {
                    Text("Some fields are incorrect. Please check that you have entered correct coordinates.")
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
            })
        }
        .autocorrectionDisabled()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.onSave()
                    dismiss()
                }
                .disabled(!viewModel.customLocationIsValid)
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        .navigationTitle("Add Location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AddPlaceForm(viewModel: AddPlaceFormViewModel(onSaveLocation: { _ in }))
    }
}
