//
//  APIClient.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 27/07/26.
//

import Foundation

enum NetworkError: Error {
    case requestError
    case invalidHTTPResponse
    case decodingError
    case httpError(code: Int)
}

protocol APIClientProtocol {
    func sendRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct APIClient: APIClientProtocol {
    let requestBuilder: RequestBuilderProtocol
    let urlSession: URLSession
    let configuration: APIConfigurationProtocol
    
    func sendRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = requestBuilder.build(configuration, endpoint)
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        if (200...299).contains(httpResponse.statusCode) {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch {
                throw NetworkError.decodingError
            }
        }
        
        throw NetworkError.httpError(code: httpResponse.statusCode)
    }
}
