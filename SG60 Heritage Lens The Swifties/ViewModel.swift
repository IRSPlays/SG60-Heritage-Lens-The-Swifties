import SwiftUI
import CoreML
import Vision
import UIKit

// ViewModel for handling CoreML predictions
class ImagePickerViewModel: ObservableObject {
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
        guard let image = self.image else {
            print("No image selected!")
            return
        }
        
        // Resize image to expected model input size (example: 224x224)
        guard let resizedImage = resizeImage(image, targetSize: CGSize(width: 224, height: 224)) else {
            print("Failed to resize image")
            return
        }

        // Convert UIImage to CIImage for Vision
        guard let ciImage = CIImage(image: resizedImage) else {
            print("Failed to convert UIImage to CIImage")
            return
        }
        
        let request = VNCoreMLRequest(model: model!) { [weak self] request, error in
            if let error = error {
                print("Prediction error: \(error.localizedDescription)")
                return
            }
            
            if let results = request.results as? [VNClassificationObservation] {
                print("Prediction results: \(results)") // Log all prediction results
                if let topResult = results.first {
                    DispatchQueue.main.async {
                        self?.prediction = "Prediction: \(topResult.identifier) with \(Int(topResult.confidence * 100))% confidence"
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.prediction = "No results"
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform image request: \(error.localizedDescription)")
        }
    }
    
    // Resize image to fit the expected model input size
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
