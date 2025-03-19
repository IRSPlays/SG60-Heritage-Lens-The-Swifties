import SwiftUI
import RealityKit
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
  supabaseKey: "YOUR_SUPABASE_ANON_KEY"
)
struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false // Track login status
    
    var body: some View {
        if isLoggedIn {
            MainAppView() // Replace with your main app content
        } else {
            LoginView()
        }
    }
}

// Main App View - Placeholder for your app's content after login
struct MainAppView: View {
    var body: some View {
        VStack {
            Text("Welcome to SG60 Heritage Lens!")
                .font(.largeTitle)
            Text("You're logged in.")
                .foregroundColor(.gray)
                .padding(.top, 12)
            Button("Logout") {
                // Logout action
                UserDefaults.standard.removeObject(forKey: "isLoggedIn") // Clear login status
            }
            .padding(.top, 24)
        }
    }
}

// Login View Component
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var authenticationMessage: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false // Binding to AppStorage

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
