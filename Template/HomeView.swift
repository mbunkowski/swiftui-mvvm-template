//
//  HomeView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text("Hello!")
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
