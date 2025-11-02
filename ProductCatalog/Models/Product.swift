//
//  Product.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import Foundation

struct Product: Identifiable, Equatable {
    let id: UUID
    var name: String
    var category: String
    var price: Double
    var isFavorite: Bool
    
    init(name: String, category: String, price: Double, isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.price = price
        self.isFavorite = isFavorite
    }
}
