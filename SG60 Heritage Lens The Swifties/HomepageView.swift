//
//  SwiftUIView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Apple on 19/3/25.
//

import SwiftUI

struct HomepageView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header with progress bar
                VStack(spacing: 5) {
                    Text("SG60 Heritage Lens")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .shadow(radius: 2)
                    
                    ProgressView(value: 0.6)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .frame(width: 200)
                        .shadow(radius: 2)
                }
                
                Text("Explore Singapore's Heritage")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                // Navigation Tabs with system icons
                HStack(spacing: 15) {
                    NavigationLink(destination: Text("ScannerView()")) {
                        Label("Scanner", systemImage: "camera.viewfinder")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: Text("FeaturedView")) {
                        Label("Featured", systemImage: "star.fill")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: Text("NearbyView()")) {
                        Label("Nearby", systemImage: "mappin.and.ellipse")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // Scanner Card
                VStack(spacing: 15) {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.red)
                    
                    Text("Landmark Scanner")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Text("Point your camera at a Singapore landmark to identify it and unlock historical information.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Button(action: {}) {
                        Text("Start Scanning")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                
                // Scanner Guide
                VStack(alignment: .leading, spacing: 10) {
                    Text("How to use the scanner")
                        .font(.headline)
                    
                    Text("1. Aim your camera at a Singapore landmark or heritage site")
                    Text("2. Hold steady while the AI analyzes the image")
                    Text("3. Explore rich historical information and earn badges")
                    Text("4. View then-and-now comparisons with historical overlays")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
                BottomNavigationBar()
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("")
        }
    }
}


struct BottomNavigationBar: View {
    var body: some View {
        HStack {
            NavigationView {
                NavigationLink(destination: Text("Achievements"))
                {
                    Label("Achievements", systemImage: "trophy")
                }
                NavigationLink(destination: Text("home")){ Label("house.fill", label: "Home")}
                BottomNavItem(icon: "map.fill", label: "Explore", isSelected: false)
                BottomNavItem(icon: "star.fill", label: "Badges", isSelected: true)
                BottomNavItem(icon: "lightbulb.fill", label: "Quiz", isSelected: false)
                BottomNavItem(icon: "person.fill", label: "Profile", isSelected: false)

            }

        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

struct BottomNavItem: View {
    let icon: String
    let label: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .red : .gray)
            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? .red : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}




// Placeholder Views
struct ScannerView: View { var body: some View { Text("Scanner View") } }
struct FeaturedView: View { var body: some View { Text("Featured View") } }
struct NearbyView: View { var body: some View { Text("Nearby View") } }
struct HomeView: View { var body: some View { Text("Home View") } }
struct ExploreView: View { var body: some View { Text("Explore View") } }
struct DiscoverView: View { var body: some View { Text("Discover View") } }
struct LeaderboardView: View { var body: some View { Text("Leaderboard View") } }





#Preview {
    HomepageView()
}

