//
//  ProductListViewModel.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import Foundation
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var searchQuery: String = "" {
        didSet { applySearchAndSort() }
    }
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let catalogService: CatalogServiceProtocol
    private var sortStrategy: ProductSortStrategy

    init(catalogService: CatalogServiceProtocol, sortStrategy: ProductSortStrategy = SortByName()) {
        self.catalogService = catalogService
        self.sortStrategy = sortStrategy
    }

    func fetchProducts() async {
        isLoading = true
        defer { isLoading = false }

        let result = await catalogService.loadProducts()
        switch result {
        case .success(let fetchedProducts):
            products = fetchedProducts
            applySearchAndSort()
        case .failure(let error):
            errorMessage = "Failed to fetch products: \(error)"
        }
    }

    func toggleFavorite(for product: Product) async {
        let result = await catalogService.toggleFavorite(product: product.id)
        switch result {
        case .success(let updatedProduct):
            if let index = products.firstIndex(where: { $0.id == updatedProduct.id }) {
                products[index] = updatedProduct
                applySearchAndSort()
            }
        case .failure(let error):
            errorMessage = "Failed to update product: \(error)"
        }
    }

    func changeSortStrategy(_ strategy: ProductSortStrategy) {
        sortStrategy = strategy
        applySearchAndSort()
    }

    private func applySearchAndSort() {
        let searched = catalogService.searchProducts(query: searchQuery, in: products)
        filteredProducts = catalogService.sortProducts(searched, using: sortStrategy)
    }
}
