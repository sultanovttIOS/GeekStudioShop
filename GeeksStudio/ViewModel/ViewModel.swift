//
//  ProductsViewModel.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class ViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var categories: [String] = []
    @Published var productsInCart: [Product] = []
    @Published var isShowCart = false
    private let networkService = NetworkService.shared
    @Published var selectedCategory: String = "All"
    private var countOfAllTours: Int = 0
    
    func addToCart(product: Product) {
        productsInCart.append(product)
        isShowCart = true
    }
    
    //MARK: Get All products
    
    func fetchProducts() async throws {
        let limit = 10
        let category = selectedCategory == "All" ? nil : selectedCategory
        do {
            let products = try await networkService.getAllProducts(
                category: category,
                limit: limit
            )
            DispatchQueue.main.async {
                self.products = products
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchCategories() async throws {
        Task {
            do {
                let categories = try await networkService.getCategories()
                DispatchQueue.main.async {
                    self.categories = ["All"] + categories
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func clearCart() {
        productsInCart.removeAll()
    }
    
    func removeFromCart(product: Product) {
        productsInCart.removeAll { $0.id == product.id }
    }
}
