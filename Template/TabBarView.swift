//
//  TabBarView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            MoreView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
            }
        }
    }
}

#Preview {
    TabBarView()
}
