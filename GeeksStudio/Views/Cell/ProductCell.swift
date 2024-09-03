//
//  ProductCell.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI

struct ProductCell: View {
    let product: Product
    var onTap: () -> Void
    
    var body: some View {
        
        VStack {
            AsyncImage(url: URL(string: product.image)) { image in
                image
                    .image?.resizable()
                    .padding()
            }
            HStack {
                Text(product.title)
                    .font(.system(size: 12, weight: .regular))
                Spacer()
                Text(formatPrice(product.price))
                    .font(.system(size: 14, weight: .regular))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        
        .background(.white)
        .cornerRadius(16)
        .onTapGesture {
            onTap()
        }
    }
    
    func formatPrice(_ price: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.positiveFormat = "#,##0.00" 
        
        let formattedPrice = formatter.string(
            from: NSNumber(
                value: price)) ?? "\(price)"
        return "\(formattedPrice) $"
    }
}

