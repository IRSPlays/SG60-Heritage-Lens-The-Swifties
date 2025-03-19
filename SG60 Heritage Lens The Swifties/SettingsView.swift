//
//  SettingsView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Sp on 19/3/25.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - App Storage Properties
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("displayLanguage") private var displayLanguage: String = "English"
    @AppStorage("heritageInfoLanguage") private var heritageInfoLanguage: String = "English"
    @AppStorage("pushNotifications") private var pushNotifications: Bool = true
    @AppStorage("nearbyHeritageAlerts") private var nearbyHeritageAlerts: Bool = true

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                // Appearance Section
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark Mode")
                    }
                }

                // Language Section
                Section(header: Text("Language")) {
                    Picker("Display Language", selection: $displayLanguage) {
                        Text("English").tag("English")
                        Text("Chinese").tag("Chinese")
                        Text("Malay").tag("Malay")
                        Text("Tamil").tag("Tamil")
                        Text("Singlish(beta)").tag("Singlish")
                        // Add more languages as needed
                    }
                    .pickerStyle(MenuPickerStyle())

                    Picker("Heritage Info Language", selection: $heritageInfoLanguage) {
                        Text("English").tag("English")
                        Text("Chinese").tag("Chinese")
                        Text("Malay").tag("Malay")
                        Text("Tamil").tag("Tamil")
                        Text("Singlish(beta)").tag("Singlish")
                        // Add more languages as needed
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                // Notifications Section
                Section(header: Text("Notifications")) {
                    Toggle(isOn: $pushNotifications) {
                        Text("Push Notifications")
                    }
                    Toggle(isOn: $nearbyHeritageAlerts) {
                        Text("Nearby Heritage Alerts")
                    }
                }

                // About Section
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0") // Hard-coded example
                    }

                    Button(action: clearAppData) {
                        Text("Clear App Data")
                            .foregroundColor(.red)
                    }

                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .onChange(of: displayLanguage) { newValue in
            // Handle UI changes or localization updates here if needed
            print("Display language changed to \(newValue)")
        }
    }

    // MARK: - Actions
    private func clearAppData() {
        // Example: Clear your app’s data, reset user defaults, etc.
        // Here you might reset certain @AppStorage properties, or
        // remove key/value pairs from UserDefaults.
        pushNotifications = false
        nearbyHeritageAlerts = false
        displayLanguage = "English"
        heritageInfoLanguage = "English"
        // Add more reset logic as needed
    }

    private func signOut() {
        // Example sign-out logic
        // Possibly clear tokens, present a login screen, etc.
        print("User signed out.")
    }
}


#Preview {
    SettingsView()
}
