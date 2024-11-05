//
//  AddLocationForm.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct AddLocationForm: View {

    var locationName: Binding<String>
    var latitude: Binding<String>
    var longitude: Binding<String>
    var fieldValidator: () -> Bool
    var onSaveCustomLocationTap: () -> Void
    var onCancelAddingCustomLocationTap: () -> Void

    var body: some View {
        Form {
            Section(content: {
                TextField("Name (optional)", text: locationName)
                    .clearButton(text: locationName)
                TextField("Latitude (between -90.0 and 90.0)", text: latitude, axis: .vertical)
                    .keyboardType(.decimalPad)
                    .clearButton(text: latitude)
                TextField("Longitude(between -180.0 and 180)", text: longitude, axis: .vertical)
                    .keyboardType(.decimalPad)
                    .clearButton(text: longitude)
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
        return !latitude.wrappedValue.isEmpty && !longitude.wrappedValue.isEmpty
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
