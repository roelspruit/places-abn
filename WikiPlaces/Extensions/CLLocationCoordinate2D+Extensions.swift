//
//  CLLocationCoordinate2D+Extensions.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 08/11/2024.
//

import CoreLocation

extension CLLocationCoordinate2D {
    /// Returns a Boolean value indicating whether this coordinate is valid.
    var isValidCoordinate: Bool {
        CLLocationCoordinate2DIsValid(self)
    }
}
