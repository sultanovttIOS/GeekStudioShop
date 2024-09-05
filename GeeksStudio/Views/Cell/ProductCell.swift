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
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                       case .empty:
                           ProgressView()
                               .frame(width: 140.5, height: 276.05)
                       case .success(let image):
                           image
                               .resizable()
                               .scaledToFit()
                               .padding(.vertical)
                       case .failure:
                           Image(systemName: "photo")
                               .resizable()
                               .scaledToFit()
                               .frame(maxWidth: 140.5, maxHeight: 276.05)
                               .foregroundColor(.gray)
                       @unknown default:
                           EmptyView()
                       }
                   }
            HStack(spacing: 16) {
                Text(product.title)
                    .font(.system(size: 12, weight: .regular))
                    .lineLimit(2)
                    .truncationMode(.tail)

                Text(formatPrice(product.price))
                    .font(.system(size: 14, weight: .regular))
            }
        }
        .padding()
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

