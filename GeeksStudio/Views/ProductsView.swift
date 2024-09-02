//
//  ProductsView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI

let screen = UIScreen.main.bounds

struct ProductsView: View {
    
    @StateObject private var viewModel = ViewModel()
    let layoutForLeft = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    @State private var showingBottomSheet = false
    @State private var selectedProduct: Product?
    @State private var isCategoryMenu = false
    @State private var selectedCategory: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: layoutForLeft, spacing: 16) {
                        ForEach(viewModel.products, id: \.id) { item in
                            ProductCell(product: item) {
                                selectedProduct = item
                                showingBottomSheet.toggle()
                            }
//                            .onAppear {
//                                if item.id == viewModel.products.last?.id {
//                                    Task {
//                                        try await viewModel.fetchProducts()
//                                    }
//                                }
//                            }
                        }
                        .frame(maxHeight: 300)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("myGrayLight"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.isShowCart.toggle()
                        }) {
                            Image("cart")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            
                            isCategoryMenu.toggle()
                        }) {
                            Image(.category)
                        }
                    }
                }
                .navigationTitle("Products")
                .sheet(isPresented: $showingBottomSheet) {
                    if let selectedProduct = selectedProduct {
                        DetailView(viewModel: viewModel, product: selectedProduct)
                            .presentationDetents([.large, .large])
                    }
                }
                .navigationDestination(isPresented: $viewModel.isShowCart,
                                       destination: {
                    CartView(viewModel: viewModel)
                })
                .onAppear() {
                    Task {
                        try await viewModel.fetchProducts()
                    }
                    Task {
                        try await viewModel.fetchCategories()
                    }
                }
            
                if isCategoryMenu {
                    CategoryMenu(viewModel: viewModel) { category in
                        selectedCategory = category
                        Task {
                            try await viewModel.fetchProducts()
                        }
                        isCategoryMenu = false
                    }
                    .zIndex(1)
                }
            }
        }
    }
}

#Preview {
    ProductsView()
}

struct CategoryButtonPositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}
