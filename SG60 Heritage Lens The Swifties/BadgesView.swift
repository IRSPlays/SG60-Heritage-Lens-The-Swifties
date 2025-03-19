//
//  BadgesView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Sp on 19/3/25.
//

//
//  ContentView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Apple on 19/3/25.
//

import SwiftUI
import RealityKit


import SwiftUI

struct BadgesView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Header Section
                        headerSection
                        
                        // Filter Buttons
                        filterButtons
                        
                        // Badges Grid
                        badgesGrid
                        
                        // Recently Unlocked Section
                        recentlyUnlockedSection
                        
                        // Coming Soon Section
                        comingSoonSection
                    }
                }
                .navigationTitle("Your Badges")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    // MARK: Subsections
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Heritage Badges")
                .font(.title2)
                .bold()
            Text("Collect badges as you explore Singapore’s heritage")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                BadgeSummaryItem(title: "1", subtitle: "Unlocked")
                BadgeSummaryItem(title: "15", subtitle: "In Progress")
                BadgeSummaryItem(title: "18", subtitle: "Total Badges")
            }
        }
        .padding(.horizontal)
    }
    
    var filterButtons: some View {
        HStack(spacing: 8) {
            FilterButton(label: "All", isSelected: true)
            FilterButton(label: "Unlocked")
            FilterButton(label: "In Progress")
        }
        .padding(.horizontal)
    }
    
    var badgesGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                  spacing: 16) {
            BadgeItem(title: "Colonial Heritage", progress: 40)
            BadgeItem(title: "Modern Marvel", progress: 60)
            BadgeItem(title: "Cultural Explorer", progress: 30)
            BadgeItem(title: "Festival Follower", progress: 15)
            BadgeItem(title: "Nostalgia Hunter", progress: 20)
            BadgeItem(title: "Art Explorer", progress: 5)
            BadgeItem(title: "Foodie Trail", progress: 70)
            BadgeItem(title: "Nature Seeker", progress: 50)
            BadgeItem(title: "Museum Master", progress: 10)
        }
        .padding(.horizontal)
    }
    
    var recentlyUnlockedSection: some View {
        VStack(alignment: .leading) {
            Text("Recently Unlocked")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            RecentlyUnlockedItem(
                title: "Marina Master",
                description: "Discover all Marina Bay attractions"
            )
        }
    }
    
    var comingSoonSection: some View {
        VStack {
            Text("Coming Soon")
                .font(.title3)
                .bold()
            Text("Complete quizzes about Singapore’s heritage to earn special badges")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: {
                // Action for "Get Notified"
            }) {
                Text("Get Notified")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

// MARK: - Subviews

struct BadgeSummaryItem: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FilterButton: View {
    let label: String
    var isSelected: Bool = false
    
    var body: some View {
        Text(label)
            .font(.subheadline)
            .fontWeight(isSelected ? .bold : .regular)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.red : Color.clear)
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: isSelected ? 0 : 1)
            )
    }
}

struct BadgeItem: View {
    let title: String
    let progress: Int
    
    var body: some View {
        VStack {
            Circle()
                .strokeBorder(Color.gray.opacity(0.4), lineWidth: 3)
                .frame(width: 60, height: 60)
                .overlay(
                    Text("\(progress)%")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                )
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}

struct RecentlyUnlockedItem: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.yellow.opacity(0.5))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
// MARK: - Preview
#Preview {
    BadgesView()
}
