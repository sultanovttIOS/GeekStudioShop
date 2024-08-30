//
//  ProductsViewModel.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import Foundation

class ProductViewModel: ObservableObject {
    
    @Published var products: [Product] = [
        Product(id: 1, title: "Banan", image: "bgFon", price: 1000, category: "sd", description: "dsd"),
        Product(id: 2, title: "Banan", image: "bgFon", price: 1000, category: "sd", description: "dsd"),
        Product(id: 3, title: "Banan", image: "bgFon", price: 1000, category: "sd", description: "dsd"),
        Product(id: 4, title: "Banan", image: "bgFon", price: 1000, category: "sd", description: "dsd"),
        Product(id: 5, title: "Banan", image: "bgFon", price: 1000, category: "sd", description: "dsd"),
        Product(id: 6, title: "Banan", image: "bgFon", price: 1000, category: "sd", description: "dsd"),
        Product(id: 7, title: "Banan", image: "bgFon", price: 1000, category: "sd", description: "dsd"),
    ]
    @Published var isShowedDetails = false
    
    var detailViewModel: DetailViewModel?
    
    func showedDetailView() {
        isShowedDetails.toggle()
    }
}
