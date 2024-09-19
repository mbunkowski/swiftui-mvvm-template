//
//  LoginView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

@MainActor
struct LoginView: View {
    
    enum Field {
        case email
        case password
    }
    
    @Environment(\.scenePhase) private var scenePhase
    
    @FocusState private var focusedField: Field?
    
    @State private var blurRadius: CGFloat = 0

    @State private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Spacer()
            TextField("Email", text: $viewModel.email)
                .frame(height: 32)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .email)
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
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity, maxHeight: 32)
                } else {
                    Text("Log In")
                        .frame(maxWidth: .infinity, maxHeight: 32)
                }
            }).buttonStyle(BorderedProminentButtonStyle())
            Button(action: {
            }, label: {
                Text("Forgot Password?")
            }).padding(.top, 12)
            Spacer()
            Button(action: {
                viewModel.isShowingRegistration = true
            }, label: {
                Text("Sign Up")
            }).buttonStyle(DefaultButtonStyle())
        }
        .padding(.horizontal, 32)
        .ignoresSafeArea(.keyboard)
        .onSubmit {
            switch focusedField {
            case .email:
                focusedField = .password
            default:
                viewModel.logIn()
            }
        }
        .fullScreenCover(isPresented: $viewModel.userSession.isAuthenticated, content: {
            TabBarView()
                .environment(viewModel.userSession)
                .blur(radius: blurRadius)
        })
        .sheet(isPresented: $viewModel.isShowingRegistration, content: {
            RegistrationView(onRegister: { tokens in
                viewModel.logIn(tokens: tokens)
            })
        })
        .onReceive(NotificationCenter.default.publisher(for: .userActivity)) { _ in
            viewModel.resetInactivityTimer()
        }
        .alert(isPresented: $viewModel.isShowingInactivityAlert, content: {
            Alert(title: Text("Log Out"), message: Text("Due to inactivity you were automatically logged out."), dismissButton: .default(Text("Ok")))
        })
        .onChange(of: scenePhase) { newScenePhase, oldScenePhase in
            switch newScenePhase {
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
