//
//  EmptyDataView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct EmptyDataView: View {
    let title: String
    let buttonTitle: String
    let buttonAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100)

            Text(title)
                .multilineTextAlignment(.center)

            Button(buttonTitle, action: buttonAction)
                .buttonStyle(.borderedProminent)
        }
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
