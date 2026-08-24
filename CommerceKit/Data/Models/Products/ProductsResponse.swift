//
//  ProductsResponse.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 28/07/26.
//

struct ProductsResponse: Decodable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Product: Decodable, Identifiable {
    let id: Int
    let title: String
    let category: String
    let price: Double
    let thumbnail: String
}
