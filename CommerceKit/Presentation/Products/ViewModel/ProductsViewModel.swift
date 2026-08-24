//
//  ProductsViewModel.swift
//  CommerceKit
//
//  Created by Sergio Andres Rodriguez Castillo on 29/07/26.
//
import Foundation
import Combine

enum ProductsState {
    case idle
    case loading
    case success(
        products: [Product],
        canLoadMore: Bool,
        isLoadingNextPage: Bool,
        paginationError: Error?
    )
    case empty
    case error(Error)
}

@MainActor
final class ProductsViewModel: ObservableObject {
    let repository: ProductsRepositoryProtocol
    @Published private(set) var state: ProductsState = .idle
    
    private let pageSize: Int = 20
    private var nextSkip: Int = 0
    
    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadInitialProducts() async {
        let previousState = state
        let previousNextSkip = nextSkip
        state = .loading
        nextSkip = 0
        
        do {
            let productsResponse = try await repository.getProducts(limit: pageSize, skip: 0)
            try Task.checkCancellation()
            
            if productsResponse.products.isEmpty {
                nextSkip = 0
                state = .empty
            } else {
                nextSkip = productsResponse.skip + productsResponse.products.count
                let canLoadMore = nextSkip < productsResponse.total
                state = .success(
                    products: productsResponse.products,
                    canLoadMore: canLoadMore,
                    isLoadingNextPage: false,
                    paginationError: nil
                )
            }
        } catch is CancellationError {
            nextSkip = previousNextSkip
            state = previousState
        } catch {
            state = .error(error)
        }
    }
    
    func getNextPage() async {
        guard case let .success(products: currentProducts,
                                canLoadMore: canLoadMore,
                                isLoadingNextPage: false,
                                paginationError: _) = state,
              canLoadMore else {
            return
        }
        
        let previousState = state
        
        state = .success(
            products: currentProducts,
            canLoadMore: canLoadMore,
            isLoadingNextPage: true,
            paginationError: nil
        )
        
        do {
            let productsResponse = try await repository.getProducts(limit: pageSize, skip: nextSkip)
            try Task.checkCancellation()
            
            if productsResponse.products.isEmpty {
                state = .success(products: currentProducts,
                                 canLoadMore: canLoadMore,
                                 isLoadingNextPage: false,
                                 paginationError: nil)
            } else {
                nextSkip = productsResponse.skip + productsResponse.products.count
                let updatedProducts = currentProducts + productsResponse.products
                let updatedCanLoadMore = nextSkip < productsResponse.total
                state = .success(
                    products: updatedProducts,
                    canLoadMore: updatedCanLoadMore,
                    isLoadingNextPage: false,
                    paginationError: nil
                )
            }
        } catch is CancellationError {
            state = previousState
        } catch {
            state = .success(products: currentProducts,
                             canLoadMore: canLoadMore,
                             isLoadingNextPage: false,
                             paginationError: error)
        }
    }
}
