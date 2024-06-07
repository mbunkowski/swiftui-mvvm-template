//
//  HTTPClient.swift
//
//  Created by Mateusz Bunkowski on 3/8/23.
//

import Foundation

class HTTPClient {
    
    static let scheme = "https"
    
    private let host: String
    
    private let session: URLSession

    init(host: String, session: URLSession = .shared) {
        self.host = host
        self.session = session
    }
    
    enum HTTPMethod: String {
        case get
        case post
        case patch
        case put
        case delete
    }
    
    // MARK: GET
    
    func get(_ path: String, queryItems: [URLQueryItem]? = nil, headers: [HTTPHeader] = []) async throws -> (Data, URLResponse) {
        let request = try urlRequest(method: .get, path: path, queryItems: queryItems, headers: headers)
        return try await session.data(for: request)
    }
    
    func get<D: Decodable>(_ path: String, queryItems: [URLQueryItem]? = nil, headers: [HTTPHeader] = [], decoder: JSONDecoder = JSONDecoder()) async throws -> D {
        let request = try urlRequest(method: .get, path: path, queryItems: queryItems, headers: headers)
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(D.self, from: data)
    }
    
    // MARK: POST
    
    func post<D: Decodable, E: Encodable>(_ path: String, body: E, headers: [HTTPHeader] = [], decoder: JSONDecoder = JSONDecoder()) async throws -> D {
        let request = try urlRequest(method: .post, path: path, body: body, headers: headers)
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(D.self, from: data)
    }
    
    // MARK: PATCH
    
    func patch<D: Decodable, E: Encodable>(_ path: String, body: E, headers: [HTTPHeader] = [], decoder: JSONDecoder = JSONDecoder()) async throws -> D {
        let request = try urlRequest(method: .patch, path: path, body: body, headers: headers)
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(D.self, from: data)
    }
    
    // MARK: PUT
    
    func put<D: Decodable, E: Encodable>(_ path: String, body: E, headers: [HTTPHeader] = [], decoder: JSONDecoder = JSONDecoder()) async throws -> D {
        let request = try urlRequest(method: .patch, path: path, body: body, headers: headers)
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(D.self, from: data)
    }
    
    // MARK: DELETE
    
    func delete<D: Decodable>(_ path: String, headers: [HTTPHeader] = [], decoder: JSONDecoder = JSONDecoder()) async throws -> D {
        let request = try urlRequest(method: .delete, path: path, headers: headers)
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(D.self, from: data)
    }
    
    // MARK: Generic helpers
    
    func urlRequest(method: HTTPMethod, path: String, queryItems: [URLQueryItem]? = nil, headers: [HTTPHeader] = []) throws -> URLRequest {
        var request = URLRequest(url: try url(for: path, queryItems: queryItems))
        request.httpMethod = method.rawValue
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.name)
        }
        return request
    }
    
    func urlRequest<E: Encodable>(method: HTTPMethod = .get, path: String, queryItems: [URLQueryItem]? = nil, body: E? = nil, headers: [HTTPHeader] = []) throws -> URLRequest {
        var request = URLRequest(url: try url(for: path, queryItems: queryItems))
        request.httpMethod = method.rawValue
        request.httpBody = try JSONEncoder().encode(body)
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.name)
        }
        return request
    }
    
    // MARK: Validation
    
    func validate(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.badServerResponse
        }
        
        let statusCode = response.statusCode
        guard 200 ..< 300 ~= statusCode else {
            throw HTTPError.statusCode(statusCode)
        }
    }
    
    // MARK: Private
    
    private func url(for path: String, queryItems: [URLQueryItem]? = nil) throws -> URL {
        var components = URLComponents()
        components.scheme = HTTPClient.scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw HTTPError.invalidURL
        }
        return url
    }
}
