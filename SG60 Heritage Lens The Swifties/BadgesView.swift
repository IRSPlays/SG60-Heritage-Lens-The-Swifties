//
//  BadgesView.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Sp on 19/3/25.
//

import SwiftUI

struct Badge: Identifiable {
    let id = UUID()
    let name: String
    let progress: Int
    let unlocked: Bool
}

class BadgeViewModel: ObservableObject {
    @Published var badges = [
        Badge(name: "Colonial Heritage", progress: 40, unlocked: false),
        Badge(name: "Modern Marvel", progress: 60, unlocked: false),
        Badge(name: "Cultural Explorer", progress: 30, unlocked: false),
        Badge(name: "Marina Master", progress: 100, unlocked: true),
        Badge(name: "History Buff", progress: 66, unlocked: false),
        Badge(name: "SG Linguist", progress: 20, unlocked: false)
    ]
}

struct BadgesView: View {
    @StateObject private var viewModel = BadgeViewModel()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Your Heritage Badges")
                        .font(.title2)
                        .bold()
                    Text("Collect badges as you explore Singapore's heritage")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                
                HStack {
                    VStack {
                        Text("\(viewModel.badges.filter { $0.unlocked }.count)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.yellow)
                        Text("Unlocked")
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack {
                        Text("\(viewModel.badges.filter { !$0.unlocked }.count)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.red)
                        Text("In Progress")
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack {
                        Text("\(viewModel.badges.count)")
                            .font(.title)
                            .bold()
                        Text("Total Badges")
                            .font(.subheadline)
                    }
                }
                .padding()
                
                List(viewModel.badges) { badge in
                    HStack {
                        Image(systemName: badge.unlocked ? "checkmark.circle.fill" : "clock")
                            .foregroundColor(badge.unlocked ? .yellow : .gray)
                        VStack(alignment: .leading) {
                            Text(badge.name)
                                .font(.headline)
                            Text("\(badge.progress)% complete")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Your Badges")
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    BadgesView()
}
