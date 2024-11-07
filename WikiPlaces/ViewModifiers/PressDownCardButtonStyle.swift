//
//  PressDownCardButtonStyle.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//

import SwiftUI

struct PressDownCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.accentColor)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.1), radius: configuration.isPressed ? 2 : 5, x: configuration.isPressed ? 0 : 5, y: configuration.isPressed ? 0 : 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .foregroundStyle(.primary)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    Button(action: {}) {
        Text("testing a button style")
            .padding()
    }
    .padding()
    .buttonStyle(PressDownCardButtonStyle())
}
