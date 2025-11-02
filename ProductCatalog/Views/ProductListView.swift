//
//  ProductListView.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import Foundation
import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel: ProductListViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading products...")
                } else {
                    productList
                }
            }
            .navigationTitle("Products")
            .searchable(text: $viewModel.searchQuery, prompt: "Search products")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    sortMenu
                }
            }
            .task {
                await viewModel.fetchProducts()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    // Error handling - in production, clear error
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
    
    private var productList: some View {
            List(viewModel.filteredProducts) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductRowView(
                        product: product,
                        onFavoriteToggle: {
                            Task {
                                await viewModel.toggleFavorite(for: product)
                            }
                        }
                    )
                }
            }
            .listStyle(.insetGrouped)
        }
        
        private var sortMenu: some View {
            Menu {
                Button {
                    viewModel.changeSortStrategy(SortByName())
                } label: {
                    Label("Sort by Name", systemImage: "textformat")
                }
                
                Button {
                    viewModel.changeSortStrategy(SortByPrice(order: .ascending))
                } label: {
                    Label("Sort by Price (Low to High)", systemImage: "arrow.up")
                }
                
                Button {
                    viewModel.changeSortStrategy(SortByPrice(order: .descending))
                } label: {
                    Label("Sort by Price (High to Low)", systemImage: "arrow.down")
                }
                
                Button {
                    viewModel.changeSortStrategy(SortByFavorite())
                } label: {
                    Label("Sort by Favorites", systemImage: "star.fill")
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
}


struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: iconForCategory(product.category))
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .padding()
            
            Text(product.name)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(product.category)
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Divider()
                .padding(.horizontal)
            
            Text("$\(product.price, specifier: "%.2f")")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.green)
            
            if product.isFavorite {
                Label("Favorite", systemImage: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "smartphones": return "iphone"
        case "laptops": return "laptopcomputer"
        case "tablets": return "ipad"
        case "audio": return "airpodspro"
        case "wearables": return "applewatch"
        case "accessories": return "keyboard"
        case "desktops": return "desktopcomputer"
        default: return "cube.box"
        }
    }
}

struct ProductRowView: View {
    let product: Product
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                
                Text(product.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("$\(product.price, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Button {
                onFavoriteToggle()
            } label: {
                Image(systemName: product.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(product.isFavorite ? .yellow : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
