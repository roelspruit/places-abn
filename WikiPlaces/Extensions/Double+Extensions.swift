//
//  Double+Extensions.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//

extension Double {
    var isValidLatitude: Bool {
        self >= -90 && self <= 90
    }

    var isValidLongitude: Bool {
        self >= -180 && self <= 180
    }
}
