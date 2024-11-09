//
//  PressDownCardButtonStyle.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//

import SwiftUI

struct PressDownCardButtonStyle: ButtonStyle {
    private let corderRadius = CGFloat(10)
    private let shadowColor = Color.black.opacity(0.1)
    private let animationDuration = TimeInterval(0.1)
    private let scaledDownSize = CGFloat(0.95)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.accentColor)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: corderRadius))
            .shadow(
                color: shadowColor,
                radius: configuration.isPressed ? 2 : 5,
                x: configuration.isPressed ? 0 : 5,
                y: configuration.isPressed ? 0 : 5
            )
            .scaleEffect(configuration.isPressed ? scaledDownSize : 1)
            .foregroundStyle(.primary)
            .animation(.easeOut(duration: animationDuration), value: configuration.isPressed)
    }
}

#Preview {
    Button(action: {}, label: {
        Text("testing a button style")
            .padding()
    })
    .padding()
    .buttonStyle(PressDownCardButtonStyle())
}
