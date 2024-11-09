//
//  PressDownCardButtonStyle.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//

import SwiftUI

struct PressDownCardButtonStyle: ButtonStyle {
    private let corderRadius = CGFloat(10)
    private let animationDuration = TimeInterval(0.1)
    private let scaledDownSize = CGFloat(0.97)

    private let shadowColor = Color.black.opacity(0.1)
    private let shadowRadius = CGFloat(7)
    private let shadowRadiusPressed = CGFloat(2)
    private let shadowOffset = CGFloat(5)
    private let shadowOffsetPressed = CGFloat(0)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.accentColor)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: corderRadius))
            .shadow(
                color: shadowColor,
                radius: configuration.isPressed ? shadowRadiusPressed : shadowRadius,
                x: configuration.isPressed ? shadowOffsetPressed : shadowOffset,
                y: configuration.isPressed ? shadowOffsetPressed : shadowOffset
            )
            .scaleEffect(configuration.isPressed ? scaledDownSize : 1)
            .foregroundStyle(.primary)
            .animation(.easeOut(duration: animationDuration), value: configuration.isPressed)
    }
}

#Preview {
    Button(action: {}, label: {
        Text("Retry")
            .padding()
    })
    .padding()
    .buttonStyle(PressDownCardButtonStyle())
}
