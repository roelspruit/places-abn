//
//  FloatingErrorMessageView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct FloatingErrorMessageView: View {

    var message: Binding<String?>

    @AccessibilityFocusState
    private var isFloatingErrorMessageFocussed: Bool

    var body: some View {
        if let floatingErrorMessage = message.wrappedValue {
            VStack(alignment: .leading) {
                Text(floatingErrorMessage)
                    .foregroundStyle(.white)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .onAppear(perform: { isFloatingErrorMessageFocussed = true})
            .onDisappear(perform: { isFloatingErrorMessageFocussed = false})
            .accessibilityFocused($isFloatingErrorMessageFocussed)
            .background(Color.abnGreen)
            .onTapGesture {
                message.wrappedValue = nil
            }
        }
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
            .overlay(alignment: .bottom) {
                FloatingErrorMessageView(message: .constant("Something went wrong"))
            }
    }
}
