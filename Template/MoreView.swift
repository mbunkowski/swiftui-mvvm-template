//
//  MoreView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

struct MoreView: View {
    
    @Environment(UserSession.self) var userSession
    
    var body: some View {
        NavigationView {
            Button("Log Out") {
                userSession.logOut()
            }
            .navigationTitle("More")
        }
    }
}

#Preview {
    MoreView()
}
