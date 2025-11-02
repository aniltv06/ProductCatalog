//
//  ProductSortStrategy.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import Foundation

protocol ProductSortStrategy {
    func sort(_ products: [Product]) -> [Product]
}

struct SortByName: ProductSortStrategy {
    func sort(_ products: [Product]) -> [Product] {
        products.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }
}

struct SortByPrice: ProductSortStrategy {
    enum SortOrder {
        case ascending
        case descending
    }
    
    let order: SortOrder
    
    func sort(_ products: [Product]) -> [Product] {
        products.sorted {
            order == .ascending ? $0.price < $1.price : $0.price > $1.price
        }
    }
}

struct SortByFavorite: ProductSortStrategy {
    func sort(_ products: [Product]) -> [Product] {
        products.sorted {
            $0.isFavorite && $1.isFavorite
        }
    }
}
