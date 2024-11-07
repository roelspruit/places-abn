//
//  CharacterInputValidation.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 07/11/2024.
//

import SwiftUI
import Combine

struct CharacterInputValidation: ViewModifier {

    @Binding var text: String

    let allowedCharacters: String

    @State private var sensoryFeedbackTrigger = false

    func body(content: Content) -> some View {
        content
            .sensoryFeedback(.error, trigger: sensoryFeedbackTrigger)
            .onChange(of: text, { _, newValue in
                let filtered = newValue.filter { allowedCharacters.contains($0) }
                if filtered != newValue {
                    sensoryFeedbackTrigger.toggle()
                    text = filtered
                }
            })
    }
}

extension View {
    /// Adds a cross icon icon on the right side of the view that will clear the contents of the given text binding when tapped.
    func characterInputValidation(text: Binding<String>, allowedCharacters: String) -> some View {
        modifier(CharacterInputValidation(text: text, allowedCharacters: allowedCharacters))
    }
}
