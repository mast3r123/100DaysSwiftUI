//
//  SaveImageView.swift
//  Day77
//
//  Created by master on 7/6/22.
//

import SwiftUI
import MapKit

struct SaveImageView: View {
    
    @State private var showingPicker = false
    @State private var imageName = ""
    @State private var showingAlert = false
    @State private var showingButton = true
    @State private var image: UIImage?
    @State private var displayImage: Image?
    let rootPath = FileManager.documentsDirectory
    @Environment (\.managedObjectContext) var moc
    let locationFetcher = LocationFetcher()
    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var location: CLLocationCoordinate2D?
    @Binding var isPresented: Bool
    
    var body: some View {
        List {
            Section(header: Text("Image Selection")) {
                ZStack {
                    if displayImage != nil {
                        displayImage?
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } else {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 300)
                            .cornerRadius(10)
                        Button {
                            showingPicker = true
                        } label: {
                            HStack {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .frame(width: 60, height: 50, alignment: .center)
                                Text("Add Image")
                            }.foregroundColor(.white)
                        }.buttonStyle(.plain)
                    }
                }.padding([.top, .bottom])
            }
            
            Section(header: Text("Image Description")) {
                TextField("Enter image description", text: $imageName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            
            if showingButton {
                Button("Add location") {
                    if let location = self.locationFetcher.lastKnownLocation {
                        self.location = location
                        showingButton = false
                        mapRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                    }
                }.font(.headline.bold())
            } else {
                Section(header: Text("Current Location")) {
                    Map(coordinateRegion: $mapRegion, showsUserLocation: true)
                        .cornerRadius(10)
                        .frame(minHeight: 200)
                        .padding([.top, .bottom])
                }
            }
            
            Button("Save") {
                tappedSave()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .font(.title3.bold())
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .alert("Please enter a valid name", isPresented: $showingAlert) {}
        
        .onChange(of: image, perform: { _ in
            importPhoto()
        })
        .sheet(isPresented: $showingPicker) {
            ImagePicker(image: $image)
        }
        .onAppear {
            locationFetcher.start()
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
        if let location = location {
            img.longitude = location.longitude
            img.latitude = location.latitude
        }
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
            return
        }
        isPresented = false
    }
}

//struct SaveImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveImageView()
//    }
//}
