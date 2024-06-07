//
//  HTTPHeader.swift
//
//  Created by Mateusz Bunkowski on 3/8/23.
//

import Foundation

struct HTTPHeader {
    let name: String
    let value: String
}

extension HTTPHeader {
    
    static func authorization(username: String, password: String) -> HTTPHeader {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()
        return authorization("Basic \(credential)")
    }
    
    public static func authorization(bearerToken: String) -> HTTPHeader {
        authorization("Bearer \(bearerToken)")
    }
    
    static func authorization(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: value)
    }
}
