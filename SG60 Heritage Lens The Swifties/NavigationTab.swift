//
//  NavigationTab.swift
//  SG60 Heritage Lens The Swifties
//
//  Created by Apple on 20/3/25.
//

import SwiftUI

struct NavigationTab: View {
    var body: some View {
        TabView {
            HomepageView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ExplorerView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Explore")
                }
            BadgesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Badges")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
            }
        }
    }

#Preview {
    NavigationTab()
}
