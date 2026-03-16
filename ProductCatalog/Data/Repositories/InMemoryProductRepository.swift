//
//  InMemoryProductRepository.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import Foundation

// Bug fix: Using actor instead of NSLock — actors provide built-in mutual exclusion
// that is safe with Swift's cooperative concurrency model.
actor InMemoryProductRepository: ProductRepositoryProtocol {

    private var products: [Product]

    init(products: [Product] = []) {
        self.products = products.isEmpty ? InMemoryProductRepository.seedProducts : products
    }

    func fetchProducts() async -> Result<[Product], ProductRepositoryError> {
        .success(products)
    }

    func toggleIsFavorite(productID: UUID) async -> Result<Product, ProductRepositoryError> {
        guard let index = products.firstIndex(where: { $0.id == productID }) else {
            return .failure(.noDataAvailable)
        }
        products[index].isFavorite.toggle()
        return .success(products[index])
    }

    static let seedProducts: [Product] = [
        Product(name: "iPhone 15 Pro", category: "Smartphones", price: 999.00),
        Product(name: "MacBook Pro 16\"", category: "Laptops", price: 2499.00),
        Product(name: "AirPods Pro", category: "Audio", price: 249.00),
        Product(name: "iPad Air", category: "Tablets", price: 599.00),
        Product(name: "Apple Watch Series 9", category: "Wearables", price: 399.00),
        Product(name: "Magic Keyboard", category: "Accessories", price: 99.00),
        Product(name: "Apple Pencil", category: "Accessories", price: 79.00),
        Product(name: "HomePod mini", category: "Audio", price: 99.00),
        Product(name: "Mac mini", category: "Desktops", price: 599.00),
        Product(name: "AirTag 4 Pack", category: "Accessories", price: 99.00),
    ]
}
