//
//  EditView.swift
//  BucketList
//
//  Created by master on 7/1/22.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var location: Location
    @State private var name: String
    @State private var description: String
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                .navigationTitle("Place details")
                .toolbar {
                    Button("Save") {
                        
                        var newLocation = location
                        newLocation.id = UUID()
                        newLocation.name = name
                        newLocation.description = description
                        onSave(newLocation)
                        dismiss()
                    }
                }
            }
        }
    }
    
    init(location: Location, onSave: @escaping
    (Location) -> Void) {
        self.onSave = onSave
        self.location = location
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
