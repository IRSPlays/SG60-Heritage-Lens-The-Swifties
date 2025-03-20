//
//  CoremlView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Apple on 20/3/25.
//

import SwiftUI
import ARKit
import RealityKit
import CoreML
import Vision

struct CoremlView: View {
    @State private var classificationResult: String = "Waiting for Object..."
    @State private var arView: ARView!
    @State private var isScanning: Bool = false
    @State private var session: ARSession!

    private var visionRequest: VNCoreMLRequest!

    init() {
        // Load the CoreML model from the app bundle
        guard let modelURL = Bundle.main.url(forResource: "YourCoreMLModel", withExtension: "mlmodelc") else {
            fatalError("CoreML model not found.")
        }
        
        // Load the ML model
        let mlModel = try! MLModel(contentsOf: modelURL)
        let coreMLModel = try! VNCoreMLModel(for: mlModel)
        
        // Create a Vision request
        visionRequest = VNCoreMLRequest(model: coreMLModel, completionHandler: handleVisionRequest)
    }

    var body: some View {
        VStack {
            Text("Object Detection & AR")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding()

            // ARView container for camera feed
            ARViewContainer(arView: $arView, classificationResult: $classificationResult)
                .edgesIgnoringSafeArea(.all)

            Spacer()
            
            // Display the classification result
            Text("Detected Object: \(classificationResult)")
                .font(.headline)
                .foregroundColor(.black)
                .padding()

            // Button to start/stop scanning
            Button(action: {
                isScanning.toggle()
                if isScanning {
                    startARSession()
                } else {
                    stopARSession()
                }
            }) {
                Text(isScanning ? "Stop Scanning" : "Start Scanning")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isScanning ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            startARSession()  // Start AR session when the view appears
        }
        .onDisappear {
            stopARSession()  // Stop AR session when the view disappears
        }
    }

    // Start the AR session
    func startARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView = ARView(frame: .zero)
        session = arView.session
        session.run(configuration)

        // Remove any previous AR anchors
        arView.scene.anchors.removeAll()
        arView.session.delegate = self
    }

    // Stop the AR session
    func stopARSession() {
        session.pause()
        arView = nil
    }

    // Handle Vision request to classify objects
    func handleVisionRequest(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation], error == nil else {
            return
        }
        
        // Get the top classification result
        if let topResult = results.first {
            DispatchQueue.main.async {
                self.classificationResult = topResult.identifier
            }
        }
    }
}

// ARViewContainer that wraps ARView for SwiftUI integration
struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView!
    @Binding var classificationResult: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Add 3D text overlay when a valid classification result is available
        if classificationResult != "Waiting for Object..." {
            let textMesh = MeshResource.generateText(classificationResult, extrusionDepth: 0.1, font: .systemFont(ofSize: 0.1))
            let material = SimpleMaterial(color: .red, isMetallic: false)
            let entity = ModelEntity(mesh: textMesh, materials: [material])

            // Create an anchor to place the 3D text 0.5 meters in front of the camera
            let anchor = AnchorEntity(world: [0, 0, -0.5])  // Adjust position if needed
            anchor.addChild(entity)
            uiView.scene.addAnchor(anchor)
        }
    }
}

// ARSessionDelegate methods for updating the AR frame
extension CoremlView: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        performVisionRequest(on: pixelBuffer)
    }
    
    // Perform Vision request to classify objects using CoreML
    func performVisionRequest(on pixelBuffer: CVPixelBuffer) {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([visionRequest])
        } catch {
            print("Error performing vision request: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CoremlView()
}
