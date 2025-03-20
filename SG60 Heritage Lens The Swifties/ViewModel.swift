import SwiftUI
import CoreML
import Vision
import UIKit

class CoremlViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var prediction: String = "Take a photo or upload an image to get a prediction"
    
    private var model: VNCoreMLModel?

    init() {
        loadModel()
    }

    private func loadModel() {
        do {
            let mlModel = try Recognition(configuration: MLModelConfiguration())
            model = try VNCoreMLModel(for: mlModel.model)
            print("Model loaded successfully.")
        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }

    // Resize image to match model's input size (e.g., 360x360)
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    // Main function to perform the prediction
    func predictImage() {
        guard let image = self.image else {
            print("No image selected")
            return
        }

        // Resize the image before passing it to CoreML
        guard let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 360, height: 360)) else {
            print("Failed to resize image")
            return
        }
        
        guard let ciImage = CIImage(image: resizedImage) else {
            print("Failed to convert UIImage to CIImage")
            return
        }

        // Create the prediction request
        let request = VNCoreMLRequest(model: model!) { [weak self] request, error in
            if let error = error {
                print("Error during prediction: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.prediction = "Error: \(error.localizedDescription)"
                }
                return
            }

            // Handle results
            if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                print("Prediction: \(topResult.identifier) with confidence: \(topResult.confidence)")
                DispatchQueue.main.async {
                    self?.prediction = "Prediction: \(topResult.identifier) with \(Int(topResult.confidence * 100))% confidence"
                }
            } else {
                DispatchQueue.main.async {
                    self?.prediction = "No results from model"
                }
                print("No results from model")
            }
        }

        // Perform the request
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
            print("Prediction request performed successfully.")
        } catch {
            print("Error performing prediction request: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.prediction = "Error performing prediction: \(error.localizedDescription)"
            }
        }
    }
}
