//
//  UserSession.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

@MainActor
@Observable
final class UserSession {
    
    private let apiLibrary: APILibrary
    
    private var tokens: Tokens?

    var isAuthenticated = false
    
    init(apiLibrary: APILibrary) {
        self.apiLibrary = apiLibrary
    }
    
    func authenticate(email: String, password: String) async throws {
        tokens = try await apiLibrary.authenticate(email: email, password: password)
        isAuthenticated = true
    }
    
    func authenticate(tokens: Tokens) {
        self.tokens = tokens
        isAuthenticated = true
    }
    
    func logOut() {
        isAuthenticated = false
        tokens = nil
    }
}
