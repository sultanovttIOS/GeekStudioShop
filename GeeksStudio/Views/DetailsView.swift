//
//  ProductDetailView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI

struct DetailsView: View {
    @State private var isAddToCart = true
    @ObservedObject var viewModel: ViewModel
    var product: Product
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
                            RatingView(rating: product.rating.rate)
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
                    Button(action: {
                        if isAddToCart {
                            viewModel.addToCart(product: product)
                            isAddToCart.toggle()
                            
                        } else {
                            isAddToCart.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack {
                            Text(isAddToCart ? "ADD TO CART" : "GO TO CART")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(
                                    isAddToCart ? Color(.myBlack) : Color(.myWhite))
                                .padding(.leading, 32)
                            Spacer()
                            Image(isAddToCart ? "cartPlus" : "cartGo")
                                .renderingMode(.template)
                                .foregroundColor(
                                    isAddToCart ? Color(.myBlack) : Color(.myWhite))
                                .padding(.trailing, 32)
                                .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(isAddToCart ? Color(.myWhite) : Color(.myBlack))
                        .clipShape(RoundedRectangle(cornerRadius: 36))
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(Color("myBlack"), lineWidth: 1)
                                .shadow(radius: 4)
                        )
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // MARK: formatPrice
    
    private func formatPrice(_ price: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal 
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.positiveFormat = "#,##0.00"
        
        let formattedPrice = formatter.string(from: NSNumber(value: price)) ?? "\(price)"
        return "\(formattedPrice) $"
    }
}
