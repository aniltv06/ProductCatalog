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
    
    private let repositoryProtocol: ProductRepositoryProtocol
    
    init(repositoryProtocol: ProductRepositoryProtocol) {
        self.repositoryProtocol = repositoryProtocol
    }
    
    func loadProducts() async -> Result<[Product], CatalogServiceError> {
        let results = await self.repositoryProtocol.fetchProducts()
        return results.mapError { CatalogServiceError.repositoryError($0) }
    }
    
    func searchProducts(query: String, in products: [Product]) -> [Product] {
        guard query.isEmpty == false else {
            return products
        }
        
        let lowercasedQuery = query.lowercased()
        
        
        return products.filter { product in
            product.name.lowercased().contains(lowercasedQuery)
        }
    }
    
    func sortProducts(_ products: [Product], using strategy: ProductSortStrategy) -> [Product] {
        strategy.sort(products)
    }
    
    func toggleFavorite(product: UUID) async -> Result<Product, CatalogServiceError> {
        let results = await self.repositoryProtocol.toggleisFavourite(productID: product)
        return results.mapError { CatalogServiceError.repositoryError($0) }
    }
}
