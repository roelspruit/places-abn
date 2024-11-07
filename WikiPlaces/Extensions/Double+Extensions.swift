//
//  Double+Extensions.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//

extension Double {
    var isValidLatitude: Bool {
        -90 <= self && self <= 90
    }

    var isValidLongitude: Bool {
        -180 <= self && self <= 180
    }
}
