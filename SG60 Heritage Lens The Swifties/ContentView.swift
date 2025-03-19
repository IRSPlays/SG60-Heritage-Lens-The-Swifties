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
                Text("Enter your username to start exploring Singapore")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)

                // Username field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .fontWeight(.semibold)
                    TextField("Your display name", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                // Password field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .fontWeight(.semibold)
                    SecureField("Your password", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                // Start Exploring button
                Button(action: {
                    print("Start Exploring tapped")
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
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 24)
            
            Spacer() // Push content upwards
        }
        .padding()
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
