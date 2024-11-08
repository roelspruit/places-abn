//
//  LoadingView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct LoadingView: View {

    let title: LocalizedStringKey

    var body: some View {
        ProgressView(title)
            .controlSize(.extraLarge)
            .padding()
            .focusAccessibilityOnAppear()
            .accessibilityLabel(title)
    }
}

#Preview {
    LoadingView(title: "Loading...")
}
