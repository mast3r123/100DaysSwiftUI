//
//  EditView.swift
//  BucketList
//
//  Created by master on 7/1/22.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby..") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            
                            if let source = page.thumbnail?.source {
                                AsyncImage(url: URL(string: source), transaction: .init(animation: .spring(response: 1.6))) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .multilineTextAlignment(.center)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    case .failure:
                                        Text("No Image Available")
                                    @unknown default:
                                        Text("")
                                    }
                                }
                                .frame(height: 120, alignment: .center)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            }
                            Text(page.description)
                                .italic()
                            Rectangle().fill(Color.gray.opacity(0.5)).frame(height: 1)
                        }.listRowSeparator(.hidden)
                    case .failed:
                        Text("Please try again later")
                    }
                }
                
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping
         (Location) -> Void) {
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
