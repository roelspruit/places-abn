//
//  LocationCardView.swift
//  WikiPlaces
//
//  Created by Roel Spruit on 06/11/2024.
//

import SwiftUI
import MapKit

struct LocationCardView: View {

    @Environment(\.openURL) var openURL

    let location: Location
    let onLocationTap: (Location, OpenURLAction) -> Void

    var body: some View {
        Button(action: {
            onLocationTap(location, openURL)
        }, label: {
            VStack {
                Map(
                    initialPosition: mapCameraPosition(forLocation: location),
                    interactionModes: []
                )
                .aspectRatio(2, contentMode: .fit)

                HStack {
                    Label(location.displayName, systemImage: location.isUserLocation ? "person" : "globe")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 5)
                .padding([.horizontal, .bottom], 15)
            }
            .accessibilityElement(children: .ignore)
        })
        .foregroundStyle(Color.accentColor)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
        .transition(.opacity)
        .accessibilityHint("Opens location in Wikipedia App")
        .accessibilityLabel(content: { _ in
            Text(location.displayName)
            if location.isUserLocation {
                Text("Custom location")
            }
        })
        .foregroundStyle(.primary)
    }

    private func mapCameraPosition(forLocation location: Location) -> MapCameraPosition {
        MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        )
    }
}

#Preview {
    LocationCardView(location: Location.examples.first!, onLocationTap: { _, _ in })
}
