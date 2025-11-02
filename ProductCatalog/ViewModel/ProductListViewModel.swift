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
        didSet {
            applySearchAndSortStrategy()
        }
    }
    
    private let catalogService: CatalogServiceProtocol
    private var productSortStrategy: ProductSortStrategy
    
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    init(catalogService: CatalogServiceProtocol, sortStrategy: ProductSortStrategy = SortByName()) {
        self.catalogService = catalogService
        self.productSortStrategy = sortStrategy
    }
    
    func fetchProducts() async {
        
        let results = await catalogService.loadProducts()
        
        switch results {
            case .success(let fetchedProducts):
            self.products = fetchedProducts
            applySearchAndSortStrategy()
        case .failure(let error):
            errorMessage = "Failed to fetch products: \(error)"
        }
    }
    
    func toggleFavorite(for product: Product) async {
        let results = await catalogService.toggleFavorite(product: product.id)
        
        switch results {
        case .success(let updatedProduct):
            if let index = self.products.firstIndex(where: {$0.id == updatedProduct.id}) {
                self.products[index] = updatedProduct
                applySearchAndSortStrategy()
            }
        case .failure(let error):
            errorMessage = "Failed to update product: \(error)"
        }
    }
    
    func changeSortStrategy(_ strategy: ProductSortStrategy) {
        self.productSortStrategy = strategy
        applySearchAndSortStrategy()
    }
   
    func applySearchAndSortStrategy() {
        let list = self.catalogService.searchProducts(query: self.searchQuery, in: self.products)
        self.filteredProducts = self.catalogService.sortProducts(list, using: self.productSortStrategy)
    }
    
}
