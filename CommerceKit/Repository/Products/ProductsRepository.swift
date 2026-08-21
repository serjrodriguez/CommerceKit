//
//  ProductsRepository.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 28/07/26.
//

import Foundation

protocol ProductsRepositoryProtocol {
    func getProducts(limit: Int, skip: Int) async throws -> ProductsResponse
}

extension ProductsRepositoryProtocol {
    func getProducts() async throws -> ProductsResponse {
        try await getProducts(limit: 20, skip: 0)
    }
}

struct ProductsRepository: ProductsRepositoryProtocol {
    let apiClient: APIClientProtocol
    
    func getProducts(limit: Int, skip: Int) async throws -> ProductsResponse {
        let endpoint = GetProductsEndpoint(limit: limit, skip: skip)
        let result: ProductsResponse = try await apiClient.sendRequest(endpoint)
        
        return result
    }
}
