//
//  CartView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 31/8/24.
//

import SwiftUI

struct CartView: View {
    @State var viewModel: ViewModel
    let layoutForCart = [GridItem(.adaptive(minimum: screen.width / 1.4))]

    var body: some View {
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: layoutForCart, spacing: 16) {
                    ForEach(viewModel.productsInCart, id: \.id) { item in
                        ProductInCartCell(product: item)
                    }
                    .frame(maxHeight: 300)
                }
                .padding(.horizontal)
            }
            Spacer()
            Button {
                
            } label: {
                Text("BUY")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("myBlack"))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .cornerRadius(36)
                    .border(Color("myBlack"))
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CartView(viewModel: ViewModel())
}
