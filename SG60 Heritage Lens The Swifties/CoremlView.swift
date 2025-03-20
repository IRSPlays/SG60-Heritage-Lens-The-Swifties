import SwiftUI
import CoreML
import Vision
import UIKit

// ViewModel for handling CoreML predictions
class Coreml: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var prediction: String = "Take a photo or upload an image to get a prediction"
    
    private var model: VNCoreMLModel?

    init() {
        loadModel()
    }
    
    private func loadModel() {
        // Make sure the model file exists
        guard let mlModel = try? Recognition(configuration: MLModelConfiguration()) else {
            print("Failed to load model")
            return
        }
        do {
            model = try VNCoreMLModel(for: mlModel.model)
        } catch {
            print("Error initializing CoreML model: \(error)")
        }
    }
    
    func predictImage() {
        guard let image = self.image else { return }
        guard let ciImage = CIImage(image: image) else { return }
        
        let request = VNCoreMLRequest(model: model!) { [weak self] request, error in
            if let results = request.results as? [VNClassificationObservation] {
                if let topResult = results.first {
                    DispatchQueue.main.async {
                        self?.prediction = "Prediction: \(topResult.identifier) with \(Int(topResult.confidence * 100))% confidence"
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
}

// Main ContentView with a nicer UI
struct CoremlView: View {
    @StateObject private var viewModel = Coreml() // Using Coreml ViewModel here
    @State private var isImagePickerPresented = false
    @State private var showActionSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Image Section
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
            } else {
                Text("No image selected")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            // Prediction Result
            Text(viewModel.prediction)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(15)
                .padding([.leading, .trailing], 20)
            
            Spacer()
            
            // Take a Photo or Upload Button
            Button(action: {
                showActionSheet.toggle()
            }) {
                Text("Take a Photo or Upload an Image")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding([.leading, .trailing], 20)
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Choose an Option"),
                    buttons: [
                        .default(Text("Take a Photo")) {
                            isImagePickerPresented = true
                        },
                        .default(Text("Choose from Library")) {
                            isImagePickerPresented = true
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $viewModel.image, sourceType: .photoLibrary)
                    .onDisappear {
                        if viewModel.image != nil {
                            viewModel.predictImage()
                        }
                    }
            }
            
            // Prediction Button
            Button(action: {
                viewModel.predictImage()
            }) {
                Text("Predict Image")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.image != nil ? Color.green : Color.gray) // Disable if no image
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .disabled(viewModel.image == nil) // Disable if no image
            .padding([.leading, .trailing], 20)
            
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CoremlView()
}
