//
//  CatalogService.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import Foundation

protocol CatalogServiceProtocol {
    func loadProducts() async -> Result<[Product], CatalogServiceError>
    func searchProducts(query: String, in products: [Product]) -> [Product]
    func sortProducts(_ products: [Product], using strategy: ProductSortStrategy) -> [Product]
    func toggleFavorite(product: UUID) async -> Result<Product, CatalogServiceError>
}

enum CatalogServiceError: Error, Equatable {
    case repositoryError(ProductRepositoryError)
    case unknown
}

struct CatalogService: CatalogServiceProtocol {

    private let repository: ProductRepositoryProtocol

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }

    func loadProducts() async -> Result<[Product], CatalogServiceError> {
        let result = await repository.fetchProducts()
        return result.mapError { CatalogServiceError.repositoryError($0) }
    }

    func searchProducts(query: String, in products: [Product]) -> [Product] {
        guard !query.isEmpty else { return products }
        let lowercasedQuery = query.lowercased()
        return products.filter { $0.name.lowercased().contains(lowercasedQuery) }
    }

    func sortProducts(_ products: [Product], using strategy: ProductSortStrategy) -> [Product] {
        strategy.sort(products)
    }

    func toggleFavorite(product: UUID) async -> Result<Product, CatalogServiceError> {
        let result = await repository.toggleIsFavorite(productID: product)
        return result.mapError { CatalogServiceError.repositoryError($0) }
    }
}
