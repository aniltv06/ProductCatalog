//
//  ProductDetailView.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import SwiftUI

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
