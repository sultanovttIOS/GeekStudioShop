//
//  ProductDetailView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI

struct DetailView: View {
    @State private var isAddToCart = true
    @ObservedObject var viewModel: ViewModel
    let product: Product
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack(alignment: .leading) {
            NavigationStack {
                ScrollView(showsIndicators: false) {
                    AsyncImage(url: URL(string: product.image)) { image in
                        image
                            .image?.resizable()
                            .padding()
                            .frame(maxHeight: 300)
                    }
                    Divider()
                        .padding(.vertical)
                        .foregroundColor(Color("myGrayAverage"))
                    VStack(alignment: .leading, spacing: 16) {
                        Text(product.title)
                            .font(.system(size: 20, weight: .regular))
                        HStack {
                            Text("Category")
                                .font(.system(size: 16, weight: .regular))
                                .frame(maxHeight: 30)
                                .foregroundColor(Color("myGrayMiddle"))
                            Text(product.category)
                                .font(.system(size: 16, weight: .regular))
                                .frame(maxHeight: 30)
                        }
                        HStack {
                            Text("Rating")
                                .font(.system(size: 16, weight: .regular))
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
                        HStack(alignment: .bottom) {
                            Text("Price")
                                .font(.system(size: 16, weight: .regular))
                                .frame(maxHeight: 24)
                                .foregroundColor(Color("myGrayMiddle"))
                            Text(formatPrice(product.price))
                                .font(.system(size: 28, weight: .regular))
                                .frame(maxHeight: 36)
                        }
                        .frame(maxHeight: 36)
                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.system(size: 16, weight: .regular))
                                .frame(maxHeight: 30)
                                .foregroundColor(Color("myGrayMiddle"))
                            Text(product.description)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color("myGrayDark"))
                                .lineSpacing(0)
                            
                        }
                    }
                }
                .padding()
                Spacer()
                
                ZStack {
                    Button {
                        if isAddToCart {
                            viewModel.addToCart(product: product)
                            isAddToCart.toggle()
                            
                        } else {
                            isAddToCart.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text(isAddToCart ? "ADD TO CART" : "GO TO CART")
                        
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(
                                isAddToCart ? Color(.myBlack) : Color(.myWhite))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .cornerRadius(36)
                            .background(
                                isAddToCart ? Color(.myWhite) : Color(.myBlack))
                            .border(Color("myBlack"))
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
    
    // MARK: formatPrice
    
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

//#Preview {
//    DetailView(viewModel: ViewModel(), product: Product(
//        id: 7,
//        title: "Banan",
//        image: "bgFon",
//        price: 1000,
//        category: "Mens slim fit",
//        description: "The color could be slightly different between on the screen and in practice. / Please note that body builds vary by person, therefore, detailed size information should be reviewed below on the product description."))
//}
