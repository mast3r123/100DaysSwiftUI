//
//  DescriptionView.swift
//  Day77
//
//  Created by master on 7/6/22.
//

import SwiftUI

struct DescriptionView: View {
    
    @State private var imageName: String
    @State private var image: Image
    @State private var uImage: UIImage?
    
    init(imageData: ImageData) {
        imageName = imageData.wrappedName
        if
            let data = try?
            Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(String(describing: imageData.wrappedId))),
           let loaded = UIImage(data: data) {
            let img = Image(uiImage: loaded)
            image = img
        } else {
            uImage = nil
            image = Image(systemName: "pencil")
        }
    }
    
    var body: some View {
        NavigationView {
        VStack(alignment: .center, spacing: 20) {
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
            Spacer()
        }.padding()
        }.navigationTitle(imageName).navigationBarTitleDisplayMode(.inline)
    }
}
