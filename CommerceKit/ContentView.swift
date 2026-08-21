//
//  ContentView.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 22/07/26.
//

import SwiftUI

struct ContentView: View {
    private let viewModel: ProductsViewModel
    
    init() {
        let configuration = APIConfiguration(environment: .development)
        let requestBuilder = RequestBuilder()
        let apiClient = APIClient(
            requestBuilder: requestBuilder,
            urlSession: .shared,
            configuration: configuration
        )
        let repository = ProductsRepository(apiClient: apiClient)
        viewModel = ProductsViewModel(repository: repository)
    }
    
    var body: some View {
        NavigationStack {
            ProductsListView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
