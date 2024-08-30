//
//  ProductCell.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI

struct ProductCell: View {
    var product: Product
    var onTap: () -> Void
    
    var body: some View {
        
        VStack {
            Image(product.image)
                .resizable()
                .padding()
            HStack {
                Text(product.title)
                    .font(.system(size: 12, weight: .regular))
                    Spacer()
                Text("\(product.price) c")
                    .font(.system(size: 14, weight: .regular))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }

        .background(.white)
        .cornerRadius(16)
        .onTapGesture {
                  onTap() // Вызов замыкания при нажатии
              }
    }
}

//#Preview {
//    ProductCell(product: Product(id: 1, title: "Banan", image: "bgFon", price: 1000, category: "wwd", description: "sd"), onTap: <#() -> Void#>)
//}
