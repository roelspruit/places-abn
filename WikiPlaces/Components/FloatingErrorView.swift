//
//  FloatingErrorView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct FloatingErrorView: View {
    @Binding var message: LocalizedStringKey?

    @State private var floatingErrorAutoHideTimer: Timer?

    private let floatingErrorAutoHideInterval: TimeInterval = 8

    var body: some View {
        if let floatingErrorMessage = $message.wrappedValue {
            VStack(alignment: .leading) {
                Text(floatingErrorMessage)
                    .foregroundStyle(.white)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .onAppear(perform: {
                startAutoHideTimer()
            })
            .focusAccessibilityOnAppear()
            .background {
                Color.popupBackground
                    .ignoresSafeArea()
                    .shadow(radius: 10)
            }
            .onTapGesture {
                hideMessage()
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private func startAutoHideTimer() {
        floatingErrorAutoHideTimer?.invalidate()
        floatingErrorAutoHideTimer = Timer.scheduledTimer(withTimeInterval: floatingErrorAutoHideInterval, repeats: false) { _ in
            Task { @MainActor in
                hideMessage()
            }
        }
    }

    private func hideMessage() {
        withAnimation {
            $message.wrappedValue = nil
        }
        floatingErrorAutoHideTimer?.invalidate()
        floatingErrorAutoHideTimer = nil
    }
}

// This viewmodifier and the extension on `View` below will make it easy to display these floating errors on top of any screen that needs it.
struct FloatingErrorViewModifier: ViewModifier {
    @Binding var message: LocalizedStringKey?
    func body(content: Content) -> some View {
        content
            .overlay(
                alignment: .bottom,
                content: {
                    FloatingErrorView(message: $message)
                }
            )
    }
}

extension View {
    /// Adds a cross icon icon on the right side of the view that will clear the contents of the given text binding when tapped.
    func floatingErrorMessage(_ message: Binding<LocalizedStringKey?>) -> some View {
        modifier(FloatingErrorViewModifier(message: message))
    }
}

#Preview {
    ZStack {
        Color.clear.ignoresSafeArea()
            .floatingErrorMessage(.constant("Something went wrong"))
    }
}
