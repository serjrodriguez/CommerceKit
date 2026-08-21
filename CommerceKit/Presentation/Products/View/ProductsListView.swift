//
//  ProductsListView.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 29/07/26.
//

import SwiftUI

struct ProductsListView: View {
    @StateObject private var viewModel: ProductsViewModel
    
    init(viewModel: ProductsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
                case .idle, .loading:
                    ProgressView()
                case let .success(products, canLoadMore, isLoadingNextPage, paginationError):
                    List {
                        ForEach(products, id: \.id) { product in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.title)
                                    Text(product.category)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(product.price, format: .currency(code: "USD"))
                            }
                            .onAppear {
                                guard product.id == products.last?.id,
                                      canLoadMore,
                                      !isLoadingNextPage else {
                                    return
                                }
                                Task {
                                    await viewModel.getNextPage()
                                }
                            }
                        }
                        
                        if let paginationError = paginationError {
                            Button("Retry") {
                                Task {
                                    await viewModel.getNextPage()
                                }
                            }
                        }
                        
                        if isLoadingNextPage {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                case .empty:
                    ContentUnavailableView {
                        Label("No Products", systemImage: "tray.fill")
                    } description: {
                        Text("There are no products available at this time.")
                    }
                case let .error(error):
                    ContentUnavailableView {
                        Label("Unable to Load Products", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error.localizedDescription)
                    } actions: {
                        Button("Retry") {
                            Task {
                                await viewModel.loadInitialProducts()
                            }
                        }
                    }
            }
        }
        .navigationTitle("Products")
        .task {
            await viewModel.loadInitialProducts()
        }
    }
}

#if DEBUG
struct ProductsRepositoryMock: ProductsRepositoryProtocol {
    func getProducts(limit: Int, skip: Int) async throws -> ProductsResponse {
        ProductsResponse(products: [.preview], total: 1, skip: 0, limit: 20)
    }
}

private extension Product {
    static let preview = Product(
        id: 1,
        title: "Essence Mascara Lash Princess",
        category: "Beauty",
        price: 9.99,
        thumbnail: ""
    )
}
#endif

#Preview {
    ProductsListView(viewModel: ProductsViewModel(repository: ProductsRepositoryMock()))
}
