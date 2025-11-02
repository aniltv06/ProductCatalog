//
//  ProductRepositoryProtocol.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import Foundation

protocol ProductRepositoryProtocol {
    func fetchProducts() async -> Result<[Product], ProductRepositoryError>
    func toggleisFavourite(productID: UUID) async -> Result<Product, ProductRepositoryError>
}

enum ProductRepositoryError: Error, Equatable {
    case noDataAvailable
    case unknown(String)
}
