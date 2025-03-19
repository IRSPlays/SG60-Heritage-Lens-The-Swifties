//
//  SettingsView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Sp on 19/3/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var isDarkMode = false
    @State private var displayLanguage = "English"
    @State private var heritageLanguage = "English"
    @State private var pushNotifications = true
    @State private var heritageAlerts = true
    
    let languages = ["English", "Spanish", "French", "German"] // Add more as needed
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                }
                
                Section(header: Text("Language")) {
                    Picker("Display Language", selection: $displayLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("Heritage Info Language", selection: $heritageLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Notifications")) {
                    Toggle(isOn: $pushNotifications) {
                        Label("Push Notifications", systemImage: "bell.fill")
                    }
                    
                    Toggle(isOn: $heritageAlerts) {
                        Label("Nearby Heritage Alerts", systemImage: "bell.badge.fill")
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0").foregroundColor(.gray)
                    }
                    
                    Text("Made for SG60").foregroundColor(.gray)
                    
                    Button(action: {
                        // Clear app data action
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear App Data")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Sign out action
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.circle.fill")
                            Text("Sign Out")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
