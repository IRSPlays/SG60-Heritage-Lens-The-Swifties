import SwiftUI
import AVFoundation
import CoreML
import Vision
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://ctzxhracmnuzetlwfqbd.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0enhocmFjbW51emV0bHdmcWJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNjM3ODQsImV4cCI6MjA1NzkzOTc4NH0.HuFPWTBw495Ja-iREz4pW62S4jjId1aAgInwxTClZCg"
)

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    var body: some View {
        if isLoggedIn {
            MainAppView()
        } else {
            LoginView()
        }
    }
}

// Main App View with Camera Scan Button
struct MainAppView: View {
    @State private var isScanning = false
    @State private var scanResult: String? = nil
    
    var body: some View {
        VStack {
            Text("Welcome to SG60 Heritage Lens!")
                .font(.largeTitle)
            Text("You're logged in.")
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            if isScanning {
                CameraScannerView(scanResult: $scanResult)
                    .frame(height: 300)
            } else {
                Button("Start Scanning") {
                    isScanning.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            if let result = scanResult {
                Text("Scan Result: \(result)")
                    .padding()
            }

            Button("Logout") {
                // Logout action
                UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            }
            .padding(.top, 24)
        }
        .padding()
    }
}

// Camera Scanner View
struct CameraScannerView: UIViewControllerRepresentable {
    @Binding var scanResult: String?

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CameraScannerView

        init(parent: CameraScannerView) {
            self.parent = parent
        }

        func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                parent.scanResult = stringValue
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoDeviceInput: AVCaptureDeviceInput
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }
        
        if (captureSession.canAddInput(videoDeviceInput)) {
            captureSession.addInput(videoDeviceInput)
        } else {
            return viewController
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13]
        } else {
            return viewController
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// Login View Component
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var authenticationMessage: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Login to your account")
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)

            if !authenticationMessage.isEmpty {
                Text(authenticationMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .font(.footnote)
            }

            Button(action: {
                authenticateUser()
            }) {
                Text("Login")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }

    // Function to authenticate the user with Supabase
    func authenticateUser() {
        guard !email.isEmpty && !password.isEmpty else {
            authenticationMessage = "Please enter your email and password."
            return
        }

        guard let url = URL(string: "https://ctzxhracmnuzetlwfqbd.supabase.co/auth/v1/token?grant_type=password") else {
            authenticationMessage = "Invalid Supabase URL."
            return
        }

        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer <your-public-anon-key>", forHTTPHeaderField: "Authorization")

        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        // Perform API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    authenticationMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    authenticationMessage = "Invalid server response."
                }
                return
            }

            if response.statusCode == 200, let data = data {
                // Parse the response to extract the JWT token if needed
                if let json = try? JSONSerialization.jsonObject(with: data),
                   let token = (json as? [String: Any])?["access_token"] as? String {
                    saveSession(token: token)
                    DispatchQueue.main.async {
                        authenticationMessage = "Login successful!"
                        isLoggedIn = true // Mark user as logged in
                    }
                } else {
                    DispatchQueue.main.async {
                        authenticationMessage = "Failed to parse server response."
                    }
                }
            } else {
                DispatchQueue.main.async {
                    authenticationMessage = "Login failed. Check your credentials."
                }
            }
        }.resume()
    }

    // Save session token (e.g., in UserDefaults or Keychain)
    private func saveSession(token: String) {
        // Save token securely here (e.g., with Keychain)
        print("Token: \(token)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
