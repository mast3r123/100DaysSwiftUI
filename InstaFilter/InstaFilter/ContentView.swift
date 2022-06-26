//
//  ContentView.swift
//  InstaFilter
//
//  Created by master on 6/19/22.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var showingPicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilterSheet = false
    
    let context = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }.onTapGesture {
                    showingPicker = true
                }
                
                VStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                    Text("Radius")
                    Slider(value: $filterRadius)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save", action: saveImage)
                        .disabled(image == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage)  { _ in loadImage() }
            .onChange(of: filterIntensity) { _ in
                applyProcessing()
            }
            .onChange(of: filterRadius) { _ in
                applyProcessing()
            }
            .sheet(isPresented: $showingPicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Group {
                    Button("Crystallize") { setFilter(newFilter: CIFilter.crystallize()) }
                    Button("Edges") { setFilter(newFilter: CIFilter.edges()) }
                    Button("Gaussian Blur") { setFilter(newFilter: CIFilter.gaussianBlur()) }
                    Button("Pixellate") { setFilter(newFilter: CIFilter.pixellate()) }
                    Button("Sepia Tone") { setFilter(newFilter: CIFilter.sepiaTone()) }
                    Button("Unsharp Mask") { setFilter(newFilter: CIFilter.unsharpMask()) }
                    Button("Vignette") { setFilter(newFilter: CIFilter.vignette()) }
                    Button("Thermal") { setFilter(newFilter: CIFilter.thermal()) }
                    Button("Comic") { setFilter(newFilter: CIFilter.comicEffect()) }
                    Button("Kaleidoscope") { setFilter(newFilter: CIFilter.kaleidoscope()) }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func saveImage() {
        guard let processedImage = processedImage else {
            return
        }
        
        let imageSaver = ImageSaver()
        
        
        imageSaver.successHandler = {
            print("Success")
        }
        
        imageSaver.errorHandler = {
            print("Oops \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing() {
        
        let inputKeys = currentFilter.inputKeys
        
        print(inputKeys)
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(newFilter: CIFilter) {
        currentFilter = newFilter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
