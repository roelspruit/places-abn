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
        floatingErrorAutoHideTimer = nil
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
