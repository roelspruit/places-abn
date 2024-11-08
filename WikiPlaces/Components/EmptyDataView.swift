//
//  EmptyDataView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct EmptyDataView: View {
    let title: LocalizedStringKey
    let buttonTitle: LocalizedStringKey
    let buttonAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.app.dashed")
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
        .padding()
    }
}

#Preview {
    EmptyDataView(
        title: "No data found",
        buttonTitle: "Retry",
        buttonAction: {}
    )
}
