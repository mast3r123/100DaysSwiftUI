//
//  SaveImageView.swift
//  Day77
//
//  Created by master on 7/6/22.
//

import SwiftUI

struct SaveImageView: View {
    
    @State private var showingPicker = false
    @State private var imageName = ""
    @State private var showingAlert = false
    @State private var image: UIImage?
    @State private var displayImage: Image?
    let rootPath = FileManager.documentsDirectory
    @Environment (\.managedObjectContext) var moc
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                if displayImage != nil {
                    displayImage?
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .fill(.secondary)
                        .frame(height: 400)
                        .cornerRadius(10)
                    Button {
                         showingPicker = true
                    } label: {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .frame(width: 70, height: 50, alignment: .center)
                    }.buttonStyle(.plain)
                }
            }
            TextField("Enter image description", text: $imageName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Button("Save") {
                tappedSave()
            }
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .font(.title3.bold())
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .padding()
        .alert("Please enter a valid name", isPresented: $showingAlert) {
            
        }
        
        .onChange(of: image, perform: { _ in
            importPhoto()
        })
        .sheet(isPresented: $showingPicker) {
            ImagePicker(image: $image)
        }
    }
    
    func importPhoto() {
        if let image = image {
            displayImage = Image(uiImage: image)
        }
    }
    
    func tappedSave() {
        if imageName.isEmpty {
            showingAlert = true
        }
        saveToDocumentsDirectory()
    }
    
    func saveToDocumentsDirectory() {
        let id = UUID()
        let savePath = rootPath.appendingPathComponent(String(describing: id))
        if let jpegData = image?.jpegData(compressionQuality: 0.8) {
            do {
                try jpegData.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        //Save to core data
        let img = ImageData(context: moc)
        img.id = id
        img.name = imageName
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}

struct SaveImageView_Previews: PreviewProvider {
    static var previews: some View {
        SaveImageView()
    }
}
