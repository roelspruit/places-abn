//
//  FocusAccessibility.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 08/11/2024.
//

import SwiftUI

struct FocusAccessibility: ViewModifier {
    @AccessibilityFocusState private var hasAccessibilityFocus: Bool

    func body(content: Content) -> some View {
        content
            .onAppear(perform: { hasAccessibilityFocus = true })
            .onDisappear(perform: { hasAccessibilityFocus = false })
            .accessibilityFocused($hasAccessibilityFocus)
    }
}

extension View {
    /// Gain accessibility focus when view appears, and dismiss accessibility focus when it disappears
    func focusAccessibilityOnAppear() -> some View {
        modifier(FocusAccessibility())
    }
}
