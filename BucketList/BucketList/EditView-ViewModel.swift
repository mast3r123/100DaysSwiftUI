//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by master on 7/3/22.
//

import Foundation

extension EditView {
    
    @MainActor class ViewModel: ObservableObject {
        
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var location: Location
        
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        @Published var name: String
        @Published var description: String
        
        init(location: Location) {
            name = location.name
            description = location.description
            self.location = location
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                return
            }            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
                print(error.localizedDescription)
            }
        }

    }
}
