//
//  ContentView.swift
//  Day77
//
//  Created by master on 7/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingSave = false
    let rootPath = FileManager.documentsDirectory
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var images: FetchedResults<ImageData>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(images, id: \.self) { img in
                        NavigationLink(destination: DescriptionView(imageData: img)) {
                            Text(img.wrappedName)
                        }
                    }
                }
            }
            .navigationTitle("Photo Log")
            .toolbar {
                Button {
                    showingSave = true
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .sheet(isPresented: $showingSave) {
                SaveImageView()
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
