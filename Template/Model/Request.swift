//
//  Request.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/29/24.
//

import Foundation

enum Request { }

extension Request {
    
    struct Login: Encodable {
        let email: String
        let password: String
    }
    
    struct RefreshSession: Encodable {
        let token: String
    }
}
