//
//  CLLocationCoordinate2D+Extensions.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 08/11/2024.
//

import CoreLocation

extension CLLocationCoordinate2D {
    var isValidCoordinate: Bool {
        CLLocationCoordinate2DIsValid(self)
    }
}
