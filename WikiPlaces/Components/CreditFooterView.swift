//
//  CreditFooterView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 10/11/2024.
//

import SwiftUI

struct CreditFooterView: View {
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack(spacing: 5) {
            Divider()

            Text("ABN AMRO Hiring Assignment 2024 by Roel Spruit.")
                .font(.caption)
                .italic()
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 5)

            Button {
                openURL(URL(string: "https://www.linkedin.com/in/roelspruit/")!)
            } label: {
                Text("Open my LinkedIn Profile")
                    .font(.caption)
            }
        }
        .accessibilityHidden(true)
        .background(Color.cardBackground.shadow(.drop(color: .black.opacity(0.1), radius: 3)))
    }
}

#Preview {
    CreditFooterView()
}
