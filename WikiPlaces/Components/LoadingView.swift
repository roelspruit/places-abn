//
//  LoadingView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct LoadingView: View {

    let title: LocalizedStringKey

    @AccessibilityFocusState private var hasAccessibilityFocus: Bool

    var body: some View {
        ProgressView(title)
            .controlSize(.extraLarge)
            .padding()
            .onAppear(perform: { hasAccessibilityFocus = true})
            .onDisappear(perform: { hasAccessibilityFocus = false})
            .accessibilityLabel(title)
            .accessibilityFocused($hasAccessibilityFocus)
    }
}

#Preview {
    LoadingView(title: "Loading...")
}
