//
//  LoginView+ViewModel.swift
//  Template
//
//  Created by Mateusz Bunkowski on 9/18/24.
//

import SwiftUI

extension LoginView {
    
    @MainActor
    @Observable
    final class ViewModel {
        
        var email: String = "test@test.com"
        var password: String = "password1"
              
        var isShowingRegistration = false
        var isShowingInactivityAlert = false

        var inactivityTimer: Timer?
        
        var userSession = UserSession(apiLibrary: APILibrary())
        
        func logIn() {
            Task { @MainActor in
                do {
                    try await self.userSession.authenticate(email: email, password: password)
                    startInactivityTimer()
                    try await Task.sleep(for: .seconds(0.5))
                    email = ""
                    password = ""
                } catch {
                    print(error)
                }
            }
        }
        
        private func startInactivityTimer() {
            inactivityTimer?.invalidate()
            inactivityTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { timer in
                Task { @MainActor in
                    self.userSession.logOut()
                    try await Task.sleep(for: .seconds(0.5))
                    self.isShowingInactivityAlert = true
                }
            })
        }
        
        func resetInactivityTimer() {
            guard userSession.isAuthenticated else { return }
            startInactivityTimer()
        }
    }
}
