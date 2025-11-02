//
//  ProductCatalogTests.swift
//  ProductCatalogTests
//
//  Created by Anil T V on 11/2/25.
//

import Testing
@testable import ProductCatalog

struct ProductCatalogTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

import XCTest
@testable import ProductCatalog

final class CatalogServiceTests: XCTestCase {
    
    // MARK: - Search Tests
    
    func testSearchProducts_WithMatchingQuery_ReturnsFilteredResults() {
        // Given
        let mockRepo = MockProductRepository()
        let sut = CatalogService(repositoryProtocol: mockRepo)
        let products = [
            Product(name: "iPhone 15", category: "Phone", price: 999),
            Product(name: "MacBook Pro", category: "Laptop", price: 2499),
            Product(name: "iPad Air", category: "Tablet", price: 599)
        ]
        
        // When
        let result = sut.searchProducts(query: "iphone", in: products)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "iPhone 15")
    }
    
    func testSearchProducts_WithEmptyQuery_ReturnsAllProducts() {
        // Given
        let mockRepo = MockProductRepository()
        let sut = CatalogService(repositoryProtocol: mockRepo)
        let products = [
            Product(name: "iPhone 15", category: "Phone", price: 999),
            Product(name: "MacBook Pro", category: "Laptop", price: 2499)
        ]
        
        // When
        let result = sut.searchProducts(query: "", in: products)
        
        // Then
        XCTAssertEqual(result.count, 2)
    }
    
    func testSearchProducts_IsCaseInsensitive() {
        // Given
        let mockRepo = MockProductRepository()
        let sut = CatalogService(repositoryProtocol: mockRepo)
        let products = [
            Product(name: "iPhone 15 Pro", category: "Phone", price: 999),
            Product(name: "MacBook Pro", category: "Laptop", price: 2499)
        ]
        
        // When
        let result1 = sut.searchProducts(query: "IPHONE", in: products)
        let result2 = sut.searchProducts(query: "iphone", in: products)
        let result3 = sut.searchProducts(query: "IpHoNe", in: products)
        
        // Then
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result2.count, 1)
        XCTAssertEqual(result3.count, 1)
    }
    
    // MARK: - Toggle Favorite Tests
    
    func testToggleFavorite_Success() async {
        // Given
        let product = Product(name: "Test", category: "Cat", price: 100, isFavorite: false)
        let mockRepo = MockProductRepository(products: [product])
        let sut = CatalogService(repositoryProtocol: mockRepo)
        
        // When
        let result = await sut.toggleFavorite(product: product.id)
        
        // Then
        switch result {
        case .success(let updatedProduct):
            XCTAssertTrue(updatedProduct.isFavorite)
        case .failure:
            XCTFail("Expected success")
        }
    }
    
    func testToggleFavorite_NotFound_ReturnsError() async {
        // Given
        let mockRepo = MockProductRepository()
        let sut = await CatalogService(repositoryProtocol: mockRepo)
        let nonExistentId = UUID()
        
        // When
        let result = await sut.toggleFavorite(product: nonExistentId)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, .repositoryError(.noDataAvailable))
        }
    }
    
    // MARK: - Sort Tests
    
    func testSortProducts_ByName() {
        // Given
        let mockRepo = MockProductRepository()
        let sut = CatalogService(repositoryProtocol: mockRepo)
        let products = [
            Product(name: "Zebra", category: "Cat", price: 100),
            Product(name: "Apple", category: "Cat", price: 100),
            Product(name: "Mango", category: "Cat", price: 100)
        ]
        
        // When
        let sorted = sut.sortProducts(products, using: SortByName())
        
        // Then
        XCTAssertEqual(sorted.map { $0.name }, ["Apple", "Mango", "Zebra"])
    }
    
    func testSortProducts_ByPriceAscending() {
        // Given
        let mockRepo = MockProductRepository()
        let sut = CatalogService(repositoryProtocol: mockRepo)
        let products = [
            Product(name: "A", category: "Cat", price: 999),
            Product(name: "B", category: "Cat", price: 99),
            Product(name: "C", category: "Cat", price: 499)
        ]
        
        // When
        let sorted = sut.sortProducts(products, using: SortByPrice(order: .ascending))
        
        // Then
        XCTAssertEqual(sorted.map { $0.price }, [99, 499, 999])
    }
    
    func testSortProducts_ByPriceDescending() {
        // Given
        let mockRepo = MockProductRepository()
        let sut = CatalogService(repositoryProtocol: mockRepo)
        let products = [
            Product(name: "A", category: "Cat", price: 99),
            Product(name: "B", category: "Cat", price: 999),
            Product(name: "C", category: "Cat", price: 499)
        ]
        
        // When
        let sorted = sut.sortProducts(products, using: SortByPrice(order: .descending))
        
        // Then
        XCTAssertEqual(sorted.map { $0.price }, [999, 499, 99])
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
    
    func toggleisFavourite(productID productId: UUID) async -> Result<Product, ProductRepositoryError> {
        guard let index = products.firstIndex(where: { $0.id == productId }) else {
            return .failure(.noDataAvailable)
        }
        
        products[index].isFavorite.toggle()
        return .success(products[index])
    }
}
