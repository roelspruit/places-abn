//
//  PlaceCardView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 06/11/2024.
//

import MapKit
import SwiftUI

struct PlaceCardView: View {
    @Environment(\.openURL) var openURL

    let place: PlaceViewModel
    let onPlaceTap: (PlaceViewModel, OpenURLAction) -> Void

    var body: some View {
        Button(action: {
            onPlaceTap(place, openURL)
        }, label: {
            VStack {
                Map(
                    initialPosition: mapCameraPosition(place: place),
                    interactionModes: []
                )
                .aspectRatio(2, contentMode: .fit)

                HStack {
                    Label(place.displayName, systemImage: place.iconName)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 5)
                .padding([.horizontal, .bottom], 15)
            }
            .accessibilityElement(children: .ignore)
        })
        .buttonStyle(PressDownCardButtonStyle())
        .transition(.opacity)
        .accessibilityHint("Opens location in Wikipedia App")
        .accessibilityLabel(content: { _ in
            if place.hasAccessibleDisplayName {
                Text(place.displayName)
            } else {
                Text("Unknown location with GPS coordinates")
            }

            if place.isUserLocation {
                Text("Custom location")
            }
        })
    }

    private func mapCameraPosition(place: PlaceViewModel) -> MapCameraPosition {
        MapCameraPosition.region(
            MKCoordinateRegion(
                center: place.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        )
    }
}

#Preview {
    PlaceCardView(place: PlaceViewModel(location: Location.examples.first!), onPlaceTap: { _, _ in })
        .padding()
}
