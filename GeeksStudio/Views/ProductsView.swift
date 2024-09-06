//
//  ProductsView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.

import SwiftUI
import CoreData

let screen = UIScreen.main.bounds

struct ProductsView: View {
    
    @StateObject private var viewModel = ViewModel()
    let layoutForItem = [GridItem(.adaptive(minimum: screen.width / 2.4),
                                  spacing: 16,
                                  alignment: .topLeading)]
    @State private var showingBottomSheet = false
    @State var selectedProduct: Product?
    @State private var isCategoryMenu = false
    @State private var selectedCategory: String?
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolling: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Products")
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundStyle(.myBlack)
                                    .opacity(isScrolling ? 0 : 1)
                                    .animation(.easeInOut(duration: 0.3), value: !isScrolling)
                                
                                Text("\(selectedCategory ?? "All")")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.myBlack)
                                    .opacity(isScrolling ? 0 : 1)
                                    .animation(.easeInOut(duration: 0.3), value: !isScrolling)
                            }
                            .padding(.leading)
                            Spacer()
                                .transition(.opacity)
                        }
                        
                        LazyVGrid(columns: layoutForItem, spacing: 16) {
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
                        }
                        .padding(.horizontal, 16)
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).minY) { newValue in
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    scrollOffset = -newValue
                                    isScrolling = newValue < 46
                                }
                            }
                    })
                }
                .onAppear {
                    viewModel.fetchProductsFromCoreData()
                    viewModel.fetchCategoriesFromCoreData()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("myGrayLight"))
                if isCategoryMenu {
                    VStack(alignment: .leading, spacing: 0) {
                        CategoryMenu(viewModel: viewModel) { category in
                            selectedCategory = category
                            isCategoryMenu = false
                        }
                    }
                    .position(x: 140, y: 145.5)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Products")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .opacity(isScrolling ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: isScrolling)
                        
                        Text(selectedCategory ?? "All")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .opacity(isScrolling ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: isScrolling)
                    }
                    .transition(.opacity)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.isShowCart.toggle()
                    }) {
                        Image(.cart)
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
            .navigationDestination(isPresented: $viewModel.isShowCart) {
                CartView(viewModel: viewModel)
            }
            .toolbarBackground(.myGrayLight)
        }
    }
}
