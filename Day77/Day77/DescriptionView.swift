//
//  DescriptionView.swift
//  Day77
//
//  Created by master on 7/6/22.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


struct DescriptionView: View {
    
    let imageData: ImageData
    let selectedImage: Image
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 50), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var locations: [Location] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                Map(coordinateRegion: $mapRegion, annotationItems: locations) {
                    MapPin(coordinate: $0.coordinate)
                }
                .cornerRadius(10)
            }.padding()
        }.navigationTitle(imageData.wrappedName).navigationBarTitleDisplayMode(.inline)
            .onAppear {
                mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: imageData.latitude, longitude: imageData.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                locations = [
                    Location(coordinate: .init(latitude: imageData.latitude, longitude: imageData.longitude))
                ]
            }
    }
}
