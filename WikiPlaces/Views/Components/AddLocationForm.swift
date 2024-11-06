//
//  AddLocationForm.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct AddLocationForm: View {

    @Binding var locationName: String
    @Binding var latitude: String
    @Binding var longitude: String

    let fieldValidator: () -> Bool
    let onSaveCustomLocationTap: () -> Void
    let onCancelAddingCustomLocationTap: () -> Void

    var body: some View {
        Form {
            Section(content: {
                TextField("Location Name (optional)", text: $locationName)
                    .clearButton(text: $locationName)
                TextField("Latitude (between -90.0 and 90.0)", text: $latitude, axis: .vertical)
                    .accessibilityHint("Value should be between -90.0 and 90.0")
                    .keyboardType(.decimalPad)
                    .clearButton(text: $latitude)
                TextField("Longitude (between -180.0 and 180)", text: $longitude, axis: .vertical)
                    .accessibilityHint("Value should be between -180.0 and 180.0")
                    .keyboardType(.decimalPad)
                    .clearButton(text: $longitude)
            }, footer: {
                if hasEnteredLocationFields && !fieldValidator() {
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
                    onSaveCustomLocationTap()
                }
                .disabled(!fieldValidator())
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    onCancelAddingCustomLocationTap()
                }
            }
        }
        .navigationTitle("Add Location")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hasEnteredLocationFields: Bool {
        return !$latitude.wrappedValue.isEmpty && !$longitude.wrappedValue.isEmpty
    }
}

#Preview {
    NavigationStack {
        AddLocationForm(
            locationName: .constant(""),
            latitude: .constant(""),
            longitude: .constant(""),
            fieldValidator: { true },
            onSaveCustomLocationTap: {},
            onCancelAddingCustomLocationTap: {}
        )
    }
}
