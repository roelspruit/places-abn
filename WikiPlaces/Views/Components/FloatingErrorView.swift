//
//  FloatingErrorView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct FloatingErrorView: View {

    var message: Binding<LocalizedStringKey?>

    @AccessibilityFocusState private var hasAccessibilityFocus: Bool
    @State private var floatingErrorAutoHideTimer: Timer?

    private let floatingErrorAutoHideInterval: TimeInterval = 8

    var body: some View {
        if let floatingErrorMessage = message.wrappedValue {
            VStack(alignment: .leading) {
                Text(floatingErrorMessage)
                    .foregroundStyle(.white)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .onAppear(perform: {
                startAutoHideTimer()
                hasAccessibilityFocus = true
            })
            .onDisappear(perform: { hasAccessibilityFocus = false})
            .accessibilityFocused($hasAccessibilityFocus)
            .background(Color.accentColor)
            .onTapGesture {
                message.wrappedValue = nil
            }
        }
    }

    private func startAutoHideTimer() {
        floatingErrorAutoHideTimer?.invalidate()
        floatingErrorAutoHideTimer = Timer.scheduledTimer(withTimeInterval: floatingErrorAutoHideInterval, repeats: false) { _ in
            Task { @MainActor in
                self.message.wrappedValue = nil
                self.floatingErrorAutoHideTimer = nil
            }
        }
    }
}

#Preview {
    ZStack {
        Color.clear.ignoresSafeArea()
            .overlay(alignment: .bottom) {
                FloatingErrorView(message: .constant("Something went wrong"))
            }
    }
}
