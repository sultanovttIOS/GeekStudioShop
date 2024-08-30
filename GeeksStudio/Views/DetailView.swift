//
//  ProductDetailView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Image(viewModel.product.image)
                .resizable()
                .padding()
            Divider()
                .foregroundColor(Color("myGrayAverage"))
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.product.title)
                    .font(.system(size: 20, weight: .regular))
                    .frame(maxHeight: 30)
                HStack {
                    Text("Category")
                        .font(.system(size: 16, weight: .regular))
                        .frame(maxHeight: 30)
                        .foregroundColor(Color("myGrayMiddle"))
                    Text(viewModel.product.title)
                        .font(.system(size: 16, weight: .regular))
                        .frame(maxHeight: 30)
                }
                HStack {
                    Text("Rating")
                        .font(.system(size: 20, weight: .regular))
                        .frame(maxHeight: 30)
                        .foregroundColor(Color("myGrayMiddle"))
                    HStack {
                        Image("starFill")
                        Image("starFill")
                        Image("starHalf")
                        Image("star")
                        Image("star")
                    }
                }
                HStack {
                    Text("Price")
                        .font(.system(size: 20, weight: .regular))
                        .frame(maxHeight: 30)
                        .foregroundColor(Color("myGrayMiddle"))
                    Text("\(viewModel.product.price)")
                        .font(.system(size: 28, weight: .regular))
                        .frame(maxHeight: 30)
                }
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.system(size: 20, weight: .regular))
                        .frame(maxHeight: 30)
                        .foregroundColor(Color("myGrayMiddle"))
                    Text(viewModel.product.description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color("myGrayDark"))

                }
                Spacer()
            }
            .padding()
            Spacer()
                .background(.gray)
                .cornerRadius(16)
        }

    }
}

#Preview {
    DetailView(viewModel: DetailViewModel(
        product: Product(
            id: 7,
            title: "Banan",
            image: "bgFon",
            price: 1000,
            category: "Mens slim fit",
            description: "The color could be slightly different between on the screen and in practice. / Please note that body builds vary by person, therefore, detailed size information should be reviewed below on the product description.")))
}
