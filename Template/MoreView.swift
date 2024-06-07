//
//  MoreView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

struct MoreView: View {
    
    @EnvironmentObject var userSession: UserSession

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
