//
//  AddPlaceForm.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import Combine
import SwiftUI

struct AddPlaceForm: View {
    @State var viewModel: AddPlaceFormViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                TextField("Location Name (optional)", text: $viewModel.locationName)
                    .clearButton(text: $viewModel.locationName)

                TextField("Latitude (between -90.0 and 90.0)", text: $viewModel.latitude, axis: .vertical)
                    .accessibilityHint("Value should be between -90.0 and 90.0")
                    .keyboardType(.numbersAndPunctuation)
                    .clearButton(text: $viewModel.latitude)
                    .characterInputValidation(text: $viewModel.latitude, allowedCharacters: "0123456789.,")

                TextField("Longitude (between -180.0 and 180)", text: $viewModel.longitude, axis: .vertical)
                    .accessibilityHint("Value should be between -180.0 and 180.0")
                    .keyboardType(.numbersAndPunctuation)
                    .clearButton(text: $viewModel.longitude)
                    .characterInputValidation(text: $viewModel.longitude, allowedCharacters: "0123456789.,")
            } header: {
                Text("Enter location information")
            } footer: {
                if viewModel.inputErrorIsShown {
                    Text("Some fields are incorrect. Please check that you have entered correct coordinates.")
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .autocorrectionDisabled()
        .sensoryFeedback(.error, trigger: viewModel.inputErrorIsShown)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.onSave()
                    dismiss()
                }
                .disabled(!viewModel.saveButtonIsEnabled)
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
