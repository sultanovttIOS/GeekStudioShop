//
//  ProductsViewModel.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import Foundation
import Combine
import SwiftUI
import CoreData

@MainActor
class ViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var categories: [String] = []
    @Published var productsInCart: [Product] = []
    @Published var isShowCart = false
    @Published var selectedCategory: String = "All"
    private let networkService = NetworkService.shared
    private let viewContext = PersistenceController.shared.container.viewContext
    
    init() {
        fetchProductsFromCoreData()
        fetchCartProductsFromCoreData()
    }
    
    // MARK: - Fetch Products from Network
    func fetchProducts() async throws {
        let limit = 20
        let category = selectedCategory == "All" ? nil : selectedCategory
        do {
            let products = try await networkService.getAllProducts(
                category: category,
                limit: limit
            )
            DispatchQueue.main.async {
                self.products = products
                self.saveProductsToCoreData(products)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Fetch Categories
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
    
    // MARK: - Cart func
    
    func addToCart(product: Product) {
        productsInCart.append(product)
        saveCartProductToCoreData(product)
        isShowCart = true
    }
    
    func clearCart() {
        productsInCart.removeAll()
        clearCartProductsFromCoreData()
        
    }
    
    func removeFromCart(product: Product) {
        productsInCart.removeAll { $0.id == product.id }
        removeCartProductFromCoreData(product)
    }
    
    // MARK: Product - Save Products to Core Data
    
    private func saveProductsToCoreData(_ products: [Product]) {
        products.forEach { product in
            // Check if the product already exists
            let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", product.id)
            
            do {
                let existingProducts = try viewContext.fetch(fetchRequest)
                let newProduct = existingProducts.first ?? ProductEntity(context: viewContext)
                
                newProduct.id = Int64(product.id)
                newProduct.title = product.title
                newProduct.price = product.price
                newProduct.desc = product.description
                newProduct.category = product.category
                newProduct.image = product.image

                try viewContext.save()
                print("Successfully saved product")
            } catch {
                print("Failed to save product: \(error.localizedDescription)")
                print("Error details: \(error)")
            }
        }
    }
    
    // MARK: - Fetch Products from Core Data
    
    func fetchProductsFromCoreData() {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        do {
            let savedProducts = try viewContext.fetch(request)
            self.products = savedProducts.map { cdProduct in
                Product(
                    id: Int(cdProduct.id),
                    title: cdProduct.title ?? "",
                    price: cdProduct.price,
                    description: cdProduct.desc ?? "",
                    category: cdProduct.category ?? "",
                    image: cdProduct.image ?? ""
                )
            }
        } catch {
            print("Failed to fetch products from Core Data: \(error.localizedDescription)")
        }
    }
    
    // MARK: Cart - saveCartProductToCoreData
    
    private func saveCartProductToCoreData(_ product: Product) {
        let fetchRequest: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", product.id)
        
        do {
            let existingProducts = try viewContext.fetch(fetchRequest)
            let cartProduct = existingProducts.first ?? CartProduct(context: viewContext)
            
            cartProduct.id = Int64(product.id)
            cartProduct.title = product.title
            cartProduct.price = product.price
            cartProduct.desc = product.description
            cartProduct.category = product.category
            cartProduct.image = product.image
            print("Saved product in cart")
            try viewContext.save()
        } catch {
            print("Failed to save cart product: \(error.localizedDescription)")
        }
    }
    
    func fetchCartProductsFromCoreData() {
        let fetchRequest: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        do {
            let savedCartProducts = try viewContext.fetch(fetchRequest)
            self.productsInCart = savedCartProducts.map { cdProduct in
                Product(
                    id: Int(cdProduct.id),
                    title: cdProduct.title ?? "",
                    price: cdProduct.price,
                    description: cdProduct.desc ?? "",
                    category: cdProduct.category ?? "",
                    image: cdProduct.image ?? ""
                )
            }
        } catch {
            print("Failed to fetch cart products from Core Data: \(error.localizedDescription)")
        }
    }
    
    private func clearCartProductsFromCoreData() {
        let fetchRequest: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        do {
            let allCartProducts = try viewContext.fetch(fetchRequest)
            for product in allCartProducts {
                viewContext.delete(product)
            }
            try viewContext.save()
            print("Cleared cart\(allCartProducts)")

        } catch {
            print("Failed to clear cart products: \(error.localizedDescription)")
        }
    }
    
    private func removeCartProductFromCoreData(_ product: Product) {
        let fetchRequest: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", product.id)
        
        do {
            let existingProducts = try viewContext.fetch(fetchRequest)
            if let cartProduct = existingProducts.first {
                viewContext.delete(cartProduct)
                try viewContext.save()
                print("Deleted product\(cartProduct)")
            }
        } catch {
            print("Failed to remove cart product: \(error.localizedDescription)")
        }
    }
}
