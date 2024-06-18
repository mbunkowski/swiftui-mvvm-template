//
//  LoginView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

struct LoginView: View {
    
    enum Field {
        case username
        case password
    }
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var viewModel = ViewModel()
    
    @FocusState private var focusedField: Field?
    
    @State var blurRadius: CGFloat = 0
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Username", text: $viewModel.username)
                .frame(height: 32)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
            Divider()
                .padding(.bottom, 4)
            SecureField("Password", text: $viewModel.password)
                .frame(height: 32)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
            Divider()
                .padding(.bottom, 30)
            Button(action: {
                viewModel.logIn()
            }, label: {
                Text("Log In")
                    .frame(maxWidth: .infinity, maxHeight: 32)
            }).buttonStyle(BorderedProminentButtonStyle())
            Button(action: {
            }, label: {
                Text("Forgot Password?")
            }).padding(.top, 12)
            Spacer()
            Button(action: {
                viewModel.signUp()
            }, label: {
                Text("Sign Up")
            }).buttonStyle(DefaultButtonStyle())
        }
        .padding(.horizontal, 32)
        .ignoresSafeArea(.keyboard)
        .onSubmit {
            switch focusedField {
            case .username:
                focusedField = .password
            default:
                viewModel.logIn()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn, content: {
            TabBarView()
                .environmentObject(UserSession(onLogOut: {
                    viewModel.logOut()
                }))
                .blur(radius: blurRadius)
        })
        .onReceive(NotificationCenter.default.publisher(for: .userActivity)) { _ in
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
