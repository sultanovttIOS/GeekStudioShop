//
//  ProductInCartCell.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 2/9/24.
//

import SwiftUI

struct ProductInCartCell: View {
    let product: Product
    @StateObject var viewModel: ViewModel

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: product.image)) { image in
                image
                    .image?.resizable()
                    .padding()
                    .scaledToFill()
                    .frame(maxWidth: 148, maxHeight: 276)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            Divider()
                .foregroundColor(Color("myGrayAverage"))
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                HStack {
                    Text(formatPrice(product.price))
                        .font(.headline)
                    Spacer()
                    
                    Button(action: {
                        viewModel.removeFromCart(product: product)
                    }) {
                        Image(.cartMinus)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    func formatPrice(_ price: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.positiveFormat = "#,##0.00"
        
        let formattedPrice = formatter.string(from: NSNumber(value: price)) ?? "\(price)"
        return "\(formattedPrice) $"
    }
}
