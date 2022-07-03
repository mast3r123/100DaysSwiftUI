//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by master on 7/2/22.
//

import Foundation
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations = [Location]()
        
        @Published var selectedPlace: Location?
        
        func addLocation() {
            let location = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(location)
        }
        
        func update(location: Location) {
            
            guard let selectedPlace = selectedPlace else {
                return
            }

            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
        }
    }

}
