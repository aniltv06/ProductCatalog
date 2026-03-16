//
//  CatalogServiceTests.swift
//  ProductCatalogTests
//
//  Created by Anil T V on 11/2/25.
//

import XCTest
@testable import ProductCatalog

final class CatalogServiceTests: XCTestCase {

    // MARK: - Search Tests

    func testSearchProducts_WithMatchingQuery_ReturnsFilteredResults() {
        let sut = CatalogService(repository: MockProductRepository())
        let products = [
            Product(name: "iPhone 15", category: "Phone", price: 999),
            Product(name: "MacBook Pro", category: "Laptop", price: 2499),
            Product(name: "iPad Air", category: "Tablet", price: 599)
        ]

        let result = sut.searchProducts(query: "iphone", in: products)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "iPhone 15")
    }

    func testSearchProducts_WithEmptyQuery_ReturnsAllProducts() {
        let sut = CatalogService(repository: MockProductRepository())
        let products = [
            Product(name: "iPhone 15", category: "Phone", price: 999),
            Product(name: "MacBook Pro", category: "Laptop", price: 2499)
        ]

        let result = sut.searchProducts(query: "", in: products)

        XCTAssertEqual(result.count, 2)
    }

    func testSearchProducts_IsCaseInsensitive() {
        let sut = CatalogService(repository: MockProductRepository())
        let products = [
            Product(name: "iPhone 15 Pro", category: "Phone", price: 999),
            Product(name: "MacBook Pro", category: "Laptop", price: 2499)
        ]

        XCTAssertEqual(sut.searchProducts(query: "IPHONE", in: products).count, 1)
        XCTAssertEqual(sut.searchProducts(query: "iphone", in: products).count, 1)
        XCTAssertEqual(sut.searchProducts(query: "IpHoNe", in: products).count, 1)
    }

    // MARK: - Toggle Favorite Tests

    func testToggleFavorite_Success() async {
        let product = Product(name: "Test", category: "Cat", price: 100, isFavorite: false)
        let sut = CatalogService(repository: MockProductRepository(products: [product]))

        let result = await sut.toggleFavorite(product: product.id)

        switch result {
        case .success(let updatedProduct):
            XCTAssertTrue(updatedProduct.isFavorite)
        case .failure:
            XCTFail("Expected success")
        }
    }

    func testToggleFavorite_NotFound_ReturnsError() async {
        let sut = CatalogService(repository: MockProductRepository())

        let result = await sut.toggleFavorite(product: UUID())

        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, .repositoryError(.noDataAvailable))
        }
    }

    // MARK: - Sort Tests

    func testSortProducts_ByName() {
        let sut = CatalogService(repository: MockProductRepository())
        let products = [
            Product(name: "Zebra", category: "Cat", price: 100),
            Product(name: "Apple", category: "Cat", price: 100),
            Product(name: "Mango", category: "Cat", price: 100)
        ]

        let sorted = sut.sortProducts(products, using: SortByName())

        XCTAssertEqual(sorted.map { $0.name }, ["Apple", "Mango", "Zebra"])
    }

    func testSortProducts_ByPriceAscending() {
        let sut = CatalogService(repository: MockProductRepository())
        let products = [
            Product(name: "A", category: "Cat", price: 999),
            Product(name: "B", category: "Cat", price: 99),
            Product(name: "C", category: "Cat", price: 499)
        ]

        let sorted = sut.sortProducts(products, using: SortByPrice(order: .ascending))

        XCTAssertEqual(sorted.map { $0.price }, [99, 499, 999])
    }

    func testSortProducts_ByPriceDescending() {
        let sut = CatalogService(repository: MockProductRepository())
        let products = [
            Product(name: "A", category: "Cat", price: 99),
            Product(name: "B", category: "Cat", price: 999),
            Product(name: "C", category: "Cat", price: 499)
        ]

        let sorted = sut.sortProducts(products, using: SortByPrice(order: .descending))

        XCTAssertEqual(sorted.map { $0.price }, [999, 499, 99])
    }

    func testSortProducts_ByFavorite_FavoritesFirst() {
        let sut = CatalogService(repository: MockProductRepository())
        let products = [
            Product(name: "A", category: "Cat", price: 100, isFavorite: false),
            Product(name: "B", category: "Cat", price: 100, isFavorite: true),
            Product(name: "C", category: "Cat", price: 100, isFavorite: false),
            Product(name: "D", category: "Cat", price: 100, isFavorite: true)
        ]

        let sorted = sut.sortProducts(products, using: SortByFavorite())

        XCTAssertTrue(sorted[0].isFavorite)
        XCTAssertTrue(sorted[1].isFavorite)
        XCTAssertFalse(sorted[2].isFavorite)
        XCTAssertFalse(sorted[3].isFavorite)
    }
}

// MARK: - Mock Repository

final class MockProductRepository: ProductRepositoryProtocol {
    private var products: [Product]

    init(products: [Product] = []) {
        self.products = products
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
}
