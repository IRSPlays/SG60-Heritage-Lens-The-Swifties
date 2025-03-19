import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ExploreView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Explore")
                }
            
            DiscoverView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Discover")
                }
            
            BadgesView()
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Badges")
                }
            
            LeaderboardView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Leaderboard")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

struct ExploreView: View {
    @State private var selectedScannerOption = 0
    let scannerOptions = ["Scanner", "Featured", "Nearby"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("SG60 Heritage")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        Text("SG60")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(8)
                    }
                    
                    Text("Lens")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.top, -12)
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow]), startPoint: .leading, endPoint: .trailing))
                        .frame(height: 4)
                        .padding(.top, 4)
                }
                .padding()
                .background(Color.white)
                
                Text("Explore Singapore's Heritage")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Scanner Options
                Picker("Scanner Options", selection: $selectedScannerOption) {
                    ForEach(0..<scannerOptions.count, id: \.self) { index in
                        Text(scannerOptions[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Scanner Card
                VStack {
                    if selectedScannerOption == 0 {
                        ScannerView()
                    } else if selectedScannerOption == 1 {
                        FeaturedView()
                    } else {
                        NearbyView()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // How to use section
                if selectedScannerOption == 0 {
                    HowToUseView()
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
            .background(Color.gray.opacity(0.1))
        }
    }
}

struct ScannerView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Landmark Scanner")
                .font(.title2)
                .fontWeight(.bold)
            
            Image(systemName: "camera.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.red)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
            
            Text("Point your camera at a Singapore landmark to identify it and unlock historical information.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                // Scanning action
            }) {
                Text("Start Scanning")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct HowToUseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to use the scanner")
                .font(.headline)
                .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Text("1.")
                        .fontWeight(.semibold)
                    Text("Aim your camera at a Singapore landmark or heritage site")
                }
                
                HStack(alignment: .top) {
                    Text("2.")
                        .fontWeight(.semibold)
                    Text("Hold steady while the AI analyzes the image")
                }
                
                HStack(alignment: .top) {
                    Text("3.")
                        .fontWeight(.semibold)
                    Text("Explore rich historical information and earn badges")
                }
                
                HStack(alignment: .top) {
                    Text("4.")
                        .fontWeight(.semibold)
                    Text("View then-and-now comparisons with historical overlays")
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct FeaturedView: View {
    var body: some View {
        Text("Featured content will appear here")
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
    }
}

struct NearbyView: View {
    var body: some View {
        Text("Nearby landmarks will appear here")
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
    }
}

// Placeholder views for other tabs
struct HomeView: View {
    var body: some View {
        Text("Home View")
    }
}

struct DiscoverView: View {
    var body: some View {
        Text("Discover View")
    }
}

struct BadgesView: View {
    var body: some View {
        Text("Badges View")
    }
}

struct LeaderboardView: View {
    var body: some View {
        Text("Leaderboard View")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}

@main
struct SG60HeritageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
