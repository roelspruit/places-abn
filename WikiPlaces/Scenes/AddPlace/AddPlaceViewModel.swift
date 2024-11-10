//
//  AddPlaceViewModel.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//
import CoreLocation
import SwiftUI

@Observable @MainActor
final class AddPlaceViewModel {
    var locationName: String = ""
    var latitude: String = ""
    var longitude: String = ""

    private let onSaveLocation: (Location?) -> Void

    var inputErrorIsShown: Bool {
        (!latitude.isEmpty && latitude.doubleValue?.isValidLatitude == false)
            || (!longitude.isEmpty && longitude.doubleValue?.isValidLongitude == false)
    }

    var saveButtonIsEnabled: Bool {
        locationFromFields != nil
    }

    init(onSaveLocation: @escaping (Location?) -> Void) {
        self.onSaveLocation = onSaveLocation
    }

    func onSave() {
        onSaveLocation(locationFromFields)
    }
}

private extension AddPlaceViewModel {
    var locationFromFields: Location? {
        guard let latitude = latitude.doubleValue,
              let longitude = longitude.doubleValue
        else {
            return nil
        }

        let sanitizedLocationName = locationName.trimmingCharacters(in: .whitespacesAndNewlines)

        let location = Location(
            name: sanitizedLocationName.isEmpty ? nil : sanitizedLocationName,
            latitude: latitude,
            longitude: longitude,
            isUserLocation: true
        )

        guard CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude).isValidCoordinate else {
            return nil
        }

        return location
    }
}
