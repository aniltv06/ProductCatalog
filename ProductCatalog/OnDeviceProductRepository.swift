//
//  OnDeviceProductRepository.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import Foundation

final class OnDeviceProductRepository: ProductRepositoryProtocol {
     
    private var products: [Product] = []
    private let lock = NSLock()
    
    init(products: [Product]) {
        self.products = products.isEmpty ? OnDeviceProductRepository.localProducts : products
    }
    
    func fetchProducts() async -> Result<[Product], ProductRepositoryError> {
        lock.lock()
        defer { self.lock.unlock() }
        return .success(self.products)
    }
    
    func toggleisFavourite(productID: UUID) async -> Result<Product, ProductRepositoryError> {
        lock.lock()
        defer { self.lock.unlock() }
        
        guard let index = products.firstIndex(where: { $0.id == productID}) else {
            return .failure(.noDataAvailable)
        }
        
        self.products[index].isFavorite.toggle()
        return .success(self.products[index])
    }
    
    static let localProducts: [Product] = [
        Product(name: "Product 1", category: "Phones", price: 10.0, isFavorite: false),
        Product(name: "Product 2", category: "Computers", price: 20.0, isFavorite: true),
        Product(name: "Product 3", category: "Phones", price: 30.0, isFavorite: false),
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
