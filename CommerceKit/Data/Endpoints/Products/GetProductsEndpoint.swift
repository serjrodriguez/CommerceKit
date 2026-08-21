//
//  GetProductsEndpoint.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 27/07/26.
//

import Foundation

struct GetProductsEndpoint: Endpoint {
    let path: String = "/products"
    
    let method: HTTPMethod = .get
    
    let headers: [String : String] = [:]
    
    let queryItems: [URLQueryItem]?
    
    let body: Data? = nil
    
    let requiresAuthentication: Bool = false

    init(limit: Int = 20, skip: Int = 0) {
        self.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "skip", value: String(skip))
        ]
    }
}
