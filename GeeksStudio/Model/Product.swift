//
//  Product.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import Foundation

struct Product: Decodable, Identifiable {
    let id: Int
    let title: String
    let price: Float
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
}

struct Rating: Decodable {
    let rate: Float
    let count: Int
}
