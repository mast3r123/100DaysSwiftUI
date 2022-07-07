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
                        let fetchedImage = getImage(id: img.id)
                        NavigationLink(destination: DescriptionView(imageData: img, selectedImage: fetchedImage)) {
                            HStack {
                                fetchedImage
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(10)
                                Text(img.wrappedName)
                                    .font(.headline.bold())
                            }
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
                SaveImageView(isPresented: $showingSave)
            }
        }
    }
    
    func getImage(id: UUID?) -> Image {
        if let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(String(describing: id!))),
           let loaded = UIImage(data: data) {
            return Image(uiImage: loaded)
        }
        return Image(systemName: "")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
