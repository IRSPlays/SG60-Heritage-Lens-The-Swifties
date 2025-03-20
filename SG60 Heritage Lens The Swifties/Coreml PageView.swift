//
//  Coreml PageView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Apple on 19/3/25.
//

import SwiftUI
import ARKit
import RealityKit
import CoreML
import Vision
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!  // AR View to display the camera feed
    @IBOutlet var classificationLabel: UILabel!  // Label to show classification result (optional)

    // CoreML Model
    var visionRequest: VNCoreMLRequest!
    
    // Classification result
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
}

// MARK: - SwiftUI Content View
struct ContentView: View {
    @State private var classificationResult: String = "Loading..."
    
    var body: some View {
        VStack {
            // Show the SwiftUI view for classification result
            Coreml_PageView(classificationResult: classificationResult)
                .onAppear {
                    // This could be tied to AR updates if you integrate ARKit with SwiftUI
                    // Update with the classification result dynamically
                    // For now, we can set a test classification result
                    self.classificationResult = "Detected: Sample Object"
                }
            
            // Optionally, show additional UI elements like AR session status or info
        }
        .onAppear {
            // Initialize or trigger ARKit logic here, or connect to ViewController
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    Coreml_PageView()
}
