//
//  String+Extensions.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//

extension String {
    /// Attempts to generate a Double out of this string. Replaces any `,` with `.` before trying.
    var doubleValue: Double? {
        let sanitizedString = replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return Double(sanitizedString)
    }
}
