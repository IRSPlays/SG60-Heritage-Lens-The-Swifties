// ProfileView.swift
// SG60 Heritage Lens The Swifties
//
// Created by Sp on 19/3/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Profile Header
                VStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 80, height: 80)
                        .overlay(Text("TE").foregroundColor(.white).font(.title))
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(.yellow)
                                .offset(x: 30, y: 30)
                        )
                    
                    Text("test")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                        Text("Level 1")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        VStack {
                            Text("2")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Landmarks")
                                .font(.caption)
                        }
                        Spacer()
                        VStack {
                            Text("1")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Badges")
                                .font(.caption)
                        }
                        Spacer()
                        VStack {
                            Text("0")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("XP")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(15)
                .padding()
                
                // Progress Bar
                VStack(alignment: .leading) {
                    Text("Overall Progress")
                        .font(.headline)
                    ProgressView(value: 0.1)
                        .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                        .frame(height: 8)
                        .cornerRadius(4)
                }
                .padding()
                
                List {
                    NavigationLink(destination: Text("Achievements")) {
                        Label("Achievements", systemImage: "trophy")
                    }
                    NavigationLink(destination: BadgesView()) {
                        Label("Badges", systemImage: "bookmark.fill")
                    }
                    NavigationLink(destination: Text("Leaderboard View")) {
                        Label("Leaderboard", systemImage: "chart.bar.fill")
                    }
                }

                Spacer()

                // Bottom Navigation Bar
                HStack {
                    Spacer()
                    NavigationLink(destination: HomepageView()) {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    Spacer()
                    NavigationLink(destination: ExplorerView()) {
                        VStack {
                            Image(systemName: "map.fill")
                            Text("Explore")
                        }
                    }
                    Spacer()
                    NavigationLink(destination: BadgesView()) {
                        VStack {
                            Image(systemName: "star.fill")
                            Text("Badges")
                        }
                    }
                    Spacer()
                    NavigationLink(destination: ProfileView()) {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                    }
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .frame(height: 60)
                .background(Color.white)
                .shadow(radius: 5)
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "gearshape.fill")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
