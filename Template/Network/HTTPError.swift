//
//  HTTPError.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import Foundation

enum HTTPError: Error {
    case invalidURL
    case statusCode(Int)
    case badServerResponse
}
