//
//  ContentView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Apple on 19/3/25.
//

import SwiftUI
import RealityKit

import SwiftUI

struct ContentView: View {
    // State variables for email, username, and password
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var authenticationMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Header section
            VStack(spacing: 4) {
                Text("SG60 Heritage Lens")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                Text("Discover Singapore's rich heritage")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            // Icons section
            HStack(spacing: 24) {
                IconView(systemName: "camera.circle.fill", label: "Discover", color: .red)
                IconView(systemName: "map.circle.fill", label: "Explore", color: .yellow)
                IconView(systemName: "person.circle.fill", label: "Earn Badges", color: .green)
            }
            .padding(.horizontal)

            Spacer().frame(height: 40) // Spacer between sections

            // Login form
            VStack(alignment: .leading, spacing: 16) {
                Text("Login to your account")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Enter your email to start exploring Singapore")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)

                // Email field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .fontWeight(.semibold)
                    TextField("Your email address", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                // Username field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .fontWeight(.semibold)
                    TextField("Your display name", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }

                // Password field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .fontWeight(.semibold)
                    SecureField("Your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }

                // Start Exploring button
                Button(action: {
                    authenticateUser()
                }) {
                    Text("Start Exploring")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .padding(.top, 16)

                // Display authentication message
                if !authenticationMessage.isEmpty {
                    Text(authenticationMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 24)
            
            Spacer() // Push content upwards
        }
        .padding()
    }

    // Function to authenticate the user with Supabase
    func authenticateUser() {
        // Validate email and password are not empty
        guard !email.isEmpty && !password.isEmpty else {
            authenticationMessage = "Email and password are required."
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
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0enhocmFjbW51emV0bHdmcWJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNjM3ODQsImV4cCI6MjA1NzkzOTc4NH0.HuFPWTBw495Ja-iREz4pW62S4jjId1aAgInwxTClZCg", forHTTPHeaderField: "Authorization")

        // Body data for authentication
        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        // Perform the API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    authenticationMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    authenticationMessage = "Invalid response from server."
                }
                return
            }

            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    authenticationMessage = "Login successful!"
                }
            } else {
                DispatchQueue.main.async {
                    authenticationMessage = "Login failed. Please check your credentials."
                }
            }
        }.resume()
    }
}

struct IconView: View {
    let systemName: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemName)
                .font(.system(size: 40))
                .foregroundColor(color)
            Text(label)
                .font(.footnote)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#Preview {
    ContentView()
}
