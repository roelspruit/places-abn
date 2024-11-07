//
//  AddPlaceFormViewModel.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//
import SwiftUI

@Observable
final class AddPlaceFormViewModel {
    var locationName: String = ""
    var latitude: String = ""
    var longitude: String = ""

    private let onSaveLocation: (Location?) -> Void

    var hasEnteredLocationFields: Bool {
        return !latitude.isEmpty && !longitude.isEmpty
    }

    var customLocationIsValid: Bool {
        locationFromFields != nil
    }

    var locationFromFields: Location? {
        // Slightly hacky: the `decimalPad` keyboard type uses comma as a separator, the Double type requires a dot separator
        guard let latitude = latitude.doubleValue,
              let longitude = longitude.doubleValue else {
            return nil
        }

        let sanitizedLocationName = locationName.trimmingCharacters(in: .whitespacesAndNewlines)

        let location = Location(
            name: sanitizedLocationName.isEmpty ? nil : sanitizedLocationName,
            latitude: latitude,
            longitude: longitude,
            isUserLocation: true
        )

        guard location.hasValidCoordinate else {
            return nil
        }

        return location
    }

    init(onSaveLocation: @escaping (Location?) -> Void) {
        self.onSaveLocation = onSaveLocation
    }

    func onSave() {
        onSaveLocation(locationFromFields)
    }
}
