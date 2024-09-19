//
//  APILibrary.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/29/24.
//

import Foundation

@MainActor
final class APILibrary: ObservableObject {

    private let client = HTTPClient(host: "localhost", port: 8080, session: .shared)
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // MARK: Routes
    
    @MainActor
    func authenticate(email: String, password: String) async throws -> Tokens {
        let req = Request.Login(email: email, password: password)
        return try await client.post("/api/auth/login", body: req, decoder: decoder)
    }

    func refreshSession(token: String) async throws -> Tokens {
        let req = Request.RefreshSession(token: token)
        return try await client.post("/api/auth/refresh-token", body: req, decoder: decoder)
    }
}

