//
//  RequestBuilder.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 27/07/26.
//
import Foundation

protocol RequestBuilderProtocol {
    func build(_ configuration: APIConfigurationProtocol, _ endpoint: Endpoint) -> URLRequest
}

struct RequestBuilder: RequestBuilderProtocol {
    func build(_ configuration: APIConfigurationProtocol, _ endpoint: Endpoint) -> URLRequest {
        var url = configuration.baseURL.appendingPathComponent(endpoint.path)
        
        if let queryItems = endpoint.queryItems {
            url = url.appending(queryItems: queryItems)
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15.0)
        request.httpMethod = endpoint.method.rawValue
        
        request.httpBody = endpoint.body
        
        for header in configuration.defaultHeaders {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        for header in endpoint.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
}
