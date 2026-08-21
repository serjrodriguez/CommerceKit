//
//  APIConfiguration.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 22/07/26.
//

import Foundation

enum Environment {
    case development
    case staging
    case production
}

protocol APIConfigurationProtocol {
    var environment: Environment { get set }
    var baseURL: URL { get }
    var defaultHeaders: [String: String] { get }
}

struct APIConfiguration: APIConfigurationProtocol {
    
    var environment: Environment
    
    var baseURL: URL {
        switch environment {
            case .development:
                return URL(string: "https://dummyjson.com")!
                
            case .staging:
                return URL(string: "https://dummyjson.com")!
                
            case .production:
                return URL(string: "https://dummyjson.com")!
        }
    }
    
    var defaultHeaders: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
