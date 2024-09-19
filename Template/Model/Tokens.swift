//
//  Tokens.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/29/24.
//

import Foundation

struct Tokens: Decodable {
    
    let accessToken: String
    let expiresAt: Date
    let refreshToken: String
}
