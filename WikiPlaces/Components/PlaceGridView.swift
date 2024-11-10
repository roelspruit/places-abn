//
//  PlaceGridView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 10/11/2024.
//

import SwiftUI

struct PlaceGridView: View {
    let places: [PlaceViewModel]
    let onPlaceTap: (PlaceViewModel, OpenURLAction) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 20) {
                ForEach(places) { place in
                    PlaceCardView(
                        place: place,
                        onPlaceTap: onPlaceTap
                    )
                }
            }
            .padding()
        }
    }
}

#Preview {
    PlaceGridView(
        places: Location.examples.map(PlaceViewModel.init),
        onPlaceTap: { _, _ in }
    )
    .padding()
}
