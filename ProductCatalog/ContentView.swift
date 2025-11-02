//
//  ContentView.swift
//  ProductCatalog
//
//  Created by Anil T V on 11/2/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ProductListView(
            viewModel: ProductListViewModel(
                catalogService: CatalogService(
                    repositoryProtocol: OnDeviceProductRepository(products: [])
                )
            )
        )
    }
}

#Preview {
    ContentView()
}
