//
//  LoginView+ViewModel.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import Foundation

extension LoginView {
    
    final class ViewModel: ObservableObject {
        
        @Published var isLoggedIn = false
                
        private var inactivityTimer: Timer?
        
        func logIn() {
            isLoggedIn = true
            startInactivityTimer()
        }
        
        func logOut() {
            isLoggedIn = false
            inactivityTimer?.invalidate()
        }
        
        func resetInactivityTimer() {
            guard isLoggedIn else { return }
            startInactivityTimer()
        }
        
        private func startInactivityTimer() {
            inactivityTimer?.invalidate()
            inactivityTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { timer in
                self.isLoggedIn = false
            })
        }
    }
}
