//
//  LoadingView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 05/11/2024.
//

import SwiftUI

struct LoadingView: View {

    let title: String

    var body: some View {
        ProgressView(title)
            .controlSize(.extraLarge)
            .padding()
    }
}

#Preview {
    LoadingView(title: "Loading...")
}
