//
//  FullscreenErrorView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct FullscreenErrorView: View {
    let title: LocalizedStringKey
    let buttonTitle: LocalizedStringKey
    let buttonAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100)
                .foregroundStyle(.secondary)

            Text(title)
                .multilineTextAlignment(.center)

            Button(buttonTitle, action: buttonAction)
                .buttonStyle(.borderedProminent)
        }
        .focusAccessibilityOnAppear()
    }
}

#Preview {
    FullscreenErrorView(
        title: "Something went wrong",
        buttonTitle: "Retry",
        buttonAction: {}
    )
}
