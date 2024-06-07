//
//  LaunchView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var isLoaded = false

    var body: some View {
        if isLoaded {
            LoginView()
                .transition(.opacity)
        } else {
            ProgressView()
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        withAnimation {
                            self.isLoaded = true
                        }
                    }
                })
        }
    }
}

#Preview {
    LaunchView()
}
