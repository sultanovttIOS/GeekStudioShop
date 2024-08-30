//
//  ProductsView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI

let screen = UIScreen.main.bounds

struct ProductsView: View {
    
    @StateObject var viewModel: ProductViewModel
    let layoutForLeft = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    @State private var showingBottomSheet = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: layoutForLeft, spacing: 16) {
                    ForEach(viewModel.products, id: \.id) { item in
                        ProductCell(product: item) {
                            selectedProduct = item
                            showingBottomSheet.toggle()
                        }
                    }
                    .frame(maxHeight: 300)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Products")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("myGrayLight"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Right button tapped")
                    }) {
                        Image("cart")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Left button tapped")
                    }) {
                        Image("category")
                    }
                }
            }
            .sheet(isPresented: $showingBottomSheet) {
                if let selectedProduct = selectedProduct {
                    let viewModel = DetailViewModel(product: selectedProduct)
                    DetailView(viewModel: viewModel)
                        .presentationDetents([.large, .large])
                }
            }
        }
    }
}

#Preview {
    ProductsView(viewModel: ProductViewModel())
}
