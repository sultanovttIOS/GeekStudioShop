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
    @Published var selectedCategory: String = "All" {
        didSet {
            filterProductsByCategory()
        }
    }
    private let networkService = NetworkService.shared
    private let viewContext = PersistenceController.shared.container.viewContext
    
    init() {
        fetchProductsFromCoreData()
        fetchCartProductsFromCoreData()
        fetchCategoriesFromCoreData()
    }
    
    // MARK: - Fetch Products from Network
    func fetchProducts() async throws {
        let limit = 30
        let category = selectedCategory == "All" ? nil : selectedCategory
        do {
            let products = try await networkService.getAllProducts(
                category: category,
                limit: limit
            )
            DispatchQueue.main.async {
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
                var uniqueCategories = Array(Set(categories)).sorted()
                
                if !uniqueCategories.contains("All") {
                    uniqueCategories.insert("All", at: 0)
                }
                DispatchQueue.main.async {
                    self.saveCategoriesToCoreData(categories)
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
                
                let rating = RatingEntity(context: viewContext)
                rating.rate = product.rating.rate
                rating.count = Int64(product.rating.count)
                newProduct.rating = rating
                
                try viewContext.save()
                print("Successfully saved product")
            } catch {
                print("Failed to save product: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Fetch Products from Core Data
    
    func fetchProductsFromCoreData() {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        do {
            let savedProducts = try viewContext.fetch(request)
            self.products = savedProducts.map { cdProduct in
                let rating: Product.Rating
                rating = Product.Rating(
                    rate: cdProduct.rating.rate,
                    count: Int(cdProduct.rating.count))
                return Product(
                    id: Int(cdProduct.id),
                    title: cdProduct.title,
                    price: cdProduct.price,
                    description: cdProduct.desc,
                    category: cdProduct.category,
                    image: cdProduct.image,
                    rating: rating
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
            
            let ratingEntity = RatingEntity(context: viewContext)
            ratingEntity.rate = product.rating.rate
            ratingEntity.count = Int64(product.rating.count)
            
            cartProduct.rating = ratingEntity
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
                
                let rating: Product.Rating
                rating = Product.Rating(
                    rate: cdProduct.rating.rate,
                    count: Int(cdProduct.rating.count)
                )
                
                return Product(
                    id: Int(cdProduct.id),
                    title: cdProduct.title,
                    price: cdProduct.price,
                    description: cdProduct.desc,
                    category: cdProduct.category,
                    image: cdProduct.image,
                    rating: rating
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
    
    //MARK: Categories
    
    // MARK: - Фильтрация продуктов по категории
    private func filterProductsByCategory() {
        if selectedCategory == "All" {
            self.products = fetchAllProductsFromCoreData()
        } else {
            self.products = fetchProductsByCategoryFromCoreData(selectedCategory)
        }
    }
    
    // MARK: - Save Categories to Core Data
    private func saveCategoriesToCoreData(_ categories: [String]) {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            let existingCategories = try viewContext.fetch(fetchRequest).compactMap { $0.title }
            let existingSet = Set(existingCategories)
            
            categories.forEach { categoryName in
                guard !existingSet.contains(categoryName) && categoryName != "All" else { return }
                
                let category = CategoryEntity(context: viewContext)
                category.title = categoryName
            }
            
            try viewContext.save()
        } catch {
            print("Failed to save categories: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch Categories from Core Data
    
    func fetchCategoriesFromCoreData() {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        do {
            var savedCategories = Array(Set(try viewContext.fetch(fetchRequest).compactMap { $0.title }))
            
            if !savedCategories.contains("All") {
                savedCategories.insert("All", at: 0)
            }
            
            self.categories = savedCategories.sorted()
        } catch {
            print("Failed to fetch categories from Core Data: \(error.localizedDescription)")
        }
    }
    
    private func fetchProductsByCategoryFromCoreData(_ category: String) -> [Product] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)
        do {
            let savedProducts = try viewContext.fetch(request)
            return savedProducts.map { cdProduct in
                let rating: Product.Rating
                rating = Product.Rating(
                    rate: cdProduct.rating.rate,
                    count: Int(cdProduct.rating.count))
                
                return Product(
                    id: Int(cdProduct.id),
                    title: cdProduct.title,
                    price: cdProduct.price,
                    description: cdProduct.desc,
                    category: cdProduct.category,
                    image: cdProduct.image,
                    rating: rating
                )
            }
        } catch {
            print("Failed to fetch products from Core Data: \(error.localizedDescription)")
            return []
        }
    }
    
    private func fetchAllProductsFromCoreData() -> [Product] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        do {
            let savedProducts = try viewContext.fetch(request)
            return savedProducts.map { cdProduct in
                let rating: Product.Rating
                rating = Product.Rating(
                    rate: cdProduct.rating.rate,
                    count: Int(cdProduct.rating.count))
                
                return Product(
                    id: Int(cdProduct.id),
                    title: cdProduct.title,
                    price: cdProduct.price,
                    description: cdProduct.desc,
                    category: cdProduct.category,
                    image: cdProduct.image,
                    rating: rating
                )
            }
        } catch {
            print("Failed to fetch products from Core Data: \(error.localizedDescription)")
            return []
        }
    }
    
}
