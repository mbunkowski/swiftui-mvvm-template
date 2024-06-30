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
        
    @FocusState private var focusedField: Field?
    
    @State var blurRadius: CGFloat = 0
    
    @State private var username: String = ""
    @State private var password: String = ""
          
    @State private var isLoggedIn = false
    @State private var isShowingRegistration = false
    @State private var isShowingInactivityAlert = false

    @State private var inactivityTimer: Timer?
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Username", text: $username)
                .frame(height: 32)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
            Divider()
                .padding(.bottom, 4)
            SecureField("Password", text: $password)
                .frame(height: 32)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
            Divider()
                .padding(.bottom, 30)
            Button(action: {
                logIn()
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
                isShowingRegistration = true
            }, label: {
                Text("Sign Up")
            }).buttonStyle(DefaultButtonStyle())
        }
        .padding(.horizontal, 32)
//        .ignoresSafeArea(.keyboard)
        .onSubmit {
            switch focusedField {
            case .username:
                focusedField = .password
            default:
                logIn()
            }
        }
        .fullScreenCover(isPresented: $isLoggedIn, content: {
            TabBarView()
                .environmentObject(UserSession(onLogOut: {
                    logOut()
                }))
                .blur(radius: blurRadius)
        })
        .sheet(isPresented: $isShowingRegistration, content: {
            RegistrationView()
        })
        .onReceive(NotificationCenter.default.publisher(for: .userActivity)) { _ in
            resetInactivityTimer()
        }
        .alert(isPresented: $isShowingInactivityAlert, content: {
            Alert(title: Text("Log Out"), message: Text("Due to inactivity you were automatically logged out."), dismissButton: .default(Text("Ok")))
        })
        .onChange(of: scenePhase) { _, newScenePhase in
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

extension LoginView {
    
    private func logIn() {
        isLoggedIn = true
        startInactivityTimer()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            username = ""
            password = ""
        }
    }
    
    private func startInactivityTimer() {
        inactivityTimer?.invalidate()
        inactivityTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            isLoggedIn = false
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                isShowingInactivityAlert = true
            }
        })
    }
    
    private func resetInactivityTimer() {
        guard isLoggedIn else { return }
        startInactivityTimer()
    }
    
    private func logOut() {
        isLoggedIn = false
        inactivityTimer?.invalidate()
    }
}

#Preview {
    LoginView()
}
