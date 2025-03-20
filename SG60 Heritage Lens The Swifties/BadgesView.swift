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


import RealityKit
import SwiftUI

struct Badge: Identifiable {
    let id = UUID()
    let name: String
    var progress: Int
    let icon: String
    
    var completionPercentage: Double {
        return min(Double(progress) / 10.0 * 100.0, 100.0)
    }
    
    var isCompleted: Bool {
        return progress >= 10
    }
}

struct BadgesView: View {
    @State var badges: [Badge] = [
        Badge(name: "Colonial Heritage", progress: ColonialHeritage, icon: "rosette"),
        Badge(name: "Modern Marvel", progress: ModernMarvel, icon: "rosette"),
        Badge(name: "Cultural Explorer", progress: CulturalExplorer, icon: "rosette"),
        Badge(name: "Marina Master", progress: MarinaMaster, icon: "map"),
        Badge(name: "History Buff", progress: HistoryPro, icon: "book"),
        Badge(name: "SG Linguist", progress: SGLinguist, icon: "character.book.closed"),
        Badge(name: "Botanist", progress: Botanist, icon: "leaf"),
        Badge(name: "Heritage Explorer", progress: HeritageExplorer, icon: "camera"),
        Badge(name: "Collection Complete", progress: CollectionComplete, icon: "archivebox.fill"),
        Badge(name: "Hawker Pro", progress: HawkerPro, icon: "fork.knife"),
        Badge(name: "Religious Harmony", progress: 0, icon: "hands.clap"),
        Badge(name: "Transit Pro", progress: TransitPro, icon: "tram.fill"),
        Badge(name: "Nature Wanderer", progress: NatureWanderer, icon: "tree"),
        Badge(name: "Local Life", progress: LocalLife, icon: "person.2"),
        Badge(name: "Festival Follower", progress: FestivalFollower, icon: "sparkles"),
        Badge(name: "Nostalgic Hunter", progress: NostalgicHunter, icon: "hourglass"),
        Badge(name: "Art Explorer", progress: ArtExplorer, icon: "paintbrush"),
    ]
    
    var totalBadges: Int {
        return badges.count
    }
    
    var earnedBadges: Int {
        return badges.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Heritage Badges")
                    .font(.title2).bold()
                    .padding(.top)
                
                Text("Earned: \(earnedBadges) / \(totalBadges)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(badges) { badge in
                            VStack {
                                Image(systemName: badge.icon)
                                    .font(.largeTitle)
                                    .foregroundColor(badge.isCompleted ? .yellow : .gray)
                                Text(badge.name)
                                    .font(.caption)
                                ProgressView(value: badge.completionPercentage, total: 100)
                                    .progressViewStyle(LinearProgressViewStyle(tint: badge.isCompleted ? .green : .red))
                                    .frame(width: 80)
                            }
                        }
                    }
                }
                
                Spacer()
                
                
            }
        }
    }
    
}
struct BadgesView_Previews: PreviewProvider {
    static var previews: some View {
        BadgesView()
    }
}

// MARK: - Preview
    
#Preview {
    BadgesView()
}
