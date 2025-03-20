import UIKit
import ARKit
import RealityKit
import CoreML
import Vision
import SwiftUI

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet var arView: ARView!  // AR View to display the camera feed
    @IBOutlet var classificationLabel: UILabel!  // Label to show classification result (optional)
    
    // CoreML Model
    var visionRequest: VNCoreMLRequest!
    
    // Classification result - using a binding to pass the result to the SwiftUI view
    @State private var classificationResult: String = "Loading..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the CoreML model
        guard let modelURL = Bundle.main.url(forResource: "The Swifties NSC 2025 1 copy 7", withExtension: "mlmodelc") else {
            fatalError("Model not found.")
        }
        
        // Create a VNCoreMLModel with the model
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else {
            fatalError("Failed to load the CoreML model.")
        }
        
        // Create a Vision request with the CoreML model
        visionRequest = VNCoreMLRequest(model: model, completionHandler: visionRequestHandler)
        
        // Configure the AR session and start AR
        configureARSession()
    }
    
    // MARK: - AR Setup
    func configureARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)
        arView.session.delegate = self
    }
    
    // MARK: - Vision Request Handler
    func visionRequestHandler(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation], error == nil else {
            return
        }
        
        // Get the top classification result
        if let topResult = results.first {
            DispatchQueue.main.async {
                self.classificationResult = topResult.identifier
                self.updateARObject(for: topResult.identifier) // Update AR object based on classification
            }
        }
    }
    
    func performVisionRequest(on pixelBuffer: CVPixelBuffer) {
        // Create the Vision request handler
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([visionRequest])
        } catch {
            print("Failed to perform Vision request: \(error.localizedDescription)")
        }
    }
    
    // Update AR based on classification result
    func updateARObject(for classification: String) {
        // If the model detected something specific, display a related 3D model
        var modelEntity: ModelEntity?
        
        // Here, add logic for different classes to load different AR models
        switch classification {
        case "Class1":  // Replace with your model's class name
            modelEntity = try? ModelEntity.loadModel(named: "Object1.usdz")
        case "Class2":  // Replace with your model's class name
            modelEntity = try? ModelEntity.loadModel(named: "Object2.usdz")
        default:
            modelEntity = try? ModelEntity.loadModel(named: "DefaultObject.usdz")
        }
        
        // If the model was successfully loaded, add it to the AR scene
        if let modelEntity = modelEntity {
            let anchorEntity = AnchorEntity(world: [0, 0, -1])  // Place object 1 meter in front of the camera
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)
        }
    }
    
    // MARK: - AR Session Delegate
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        performVisionRequest(on: pixelBuffer)
    }
    
    // MARK: - SwiftUI Content View
    func showCoremlPageView() -> some View {
        Coreml_PageView(classificationResult: $classificationResult) // Bind the classification result to the Coreml_PageView
    }
    
    // Function to show the SwiftUI view inside the ViewController (optional, if you need it in the ViewController)
    func displayCoremlPageView() {
        let coremlPageView = showCoremlPageView()
        let hostingController = UIHostingController(rootView: coremlPageView)
        present(hostingController, animated: true, completion: nil)
    }
}

