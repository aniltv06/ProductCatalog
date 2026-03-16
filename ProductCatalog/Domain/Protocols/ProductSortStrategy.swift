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
    nonisolated init() {}

    func sort(_ products: [Product]) -> [Product] {
        products.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}

struct SortByPrice: ProductSortStrategy {
    enum SortOrder {
        case ascending
        case descending
    }

    let order: SortOrder

    nonisolated init(order: SortOrder) { self.order = order }

    func sort(_ products: [Product]) -> [Product] {
        products.sorted {
            order == .ascending ? $0.price < $1.price : $0.price > $1.price
        }
    }
}

struct SortByFavorite: ProductSortStrategy {
    nonisolated init() {}

    func sort(_ products: [Product]) -> [Product] {
        // Bug fix: favorites ($0.isFavorite == true) come before non-favorites
        products.sorted { $0.isFavorite && !$1.isFavorite }
    }
}
