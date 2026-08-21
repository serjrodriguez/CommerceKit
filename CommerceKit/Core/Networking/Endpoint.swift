//
//  Endpoint.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 22/07/26.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var requiresAuthentication: Bool { get }
}
