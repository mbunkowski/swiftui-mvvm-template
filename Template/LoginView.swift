//
//  LoginView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var viewModel = ViewModel()
    
    @State var blurRadius : CGFloat = 0

    var body: some View {
        ZStack{
            Button(action: {
                viewModel.logIn()
            }, label: {
                Text("Log In")
                    .frame(width: 200, height: 32)
            })
            .buttonStyle(BorderedProminentButtonStyle())
            .fullScreenCover(isPresented: $viewModel.isLoggedIn, content: {
                TabBarView()
                    .environmentObject(UserSession(onLogOut: {
                        viewModel.logOut()
                    }))
                    .blur(radius: blurRadius)
            })
        }.onReceive(NotificationCenter.default.publisher(for: .userActivity)) { _ in
            viewModel.resetInactivityTimer()
        }.onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                withAnimation { blurRadius = 0 }
            case .inactive:
                withAnimation { blurRadius = 10 }
            case .background:
                withAnimation { blurRadius = 20 }
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    LoginView()
}
