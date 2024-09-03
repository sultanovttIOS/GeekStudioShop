//
//  ProductsView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI
import CoreData

let screen = UIScreen.main.bounds

struct ProductsView: View {
    
    @StateObject private var viewModel = ViewModel()
    let layoutForLeft = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    @State private var showingBottomSheet = false
    @State var selectedProduct: Product?
    @State private var isCategoryMenu = false
    @State private var selectedCategory: String?


    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: layoutForLeft, spacing: 16) {
                        ForEach(viewModel.products, id: \.id) { product in
                            ProductCell(product: product) {
                                if isCategoryMenu {
                                    isCategoryMenu = false
                                } else {
                                    self.selectedProduct = product
                                    showingBottomSheet.toggle()
                                }
                            }
                        }
                        .frame(maxHeight: 300)
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    viewModel.fetchProductsFromCoreData()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("myGrayLight"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Products")
                                .font(.headline)
                                .foregroundColor(.myBlack)
                            Text(selectedCategory ?? "All")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
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
                .sheet(item: $selectedProduct) { selectedProduct in
                    DetailsView(viewModel: viewModel, product: selectedProduct)
                }
                
                .navigationDestination(isPresented: $viewModel.isShowCart,
                                       destination: {
                    CartView(viewModel: viewModel)
                })
                .onAppear() {
                    viewModel.fetchProductsFromCoreData()
                    Task {
//                        try await viewModel.fetchProducts()
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

