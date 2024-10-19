//
//  TextFieldClearButton.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 19/10/2024.
//

import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {

        HStack {
            content
            if !text.isEmpty {
                Button {
                    text = ""
                }label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
            }
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
}
