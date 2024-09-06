//
//  CartView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 31/8/24.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: ViewModel
    let layoutForCart = [GridItem(.adaptive(minimum: screen.width / 1.4))]
    @State var cartIsEmpty = false
    @Environment(\.dismiss) var dismiss
    @State var buyIsActive = false
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolling: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.productsInCart.isEmpty {
                Spacer()
                Text("Empty")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(.myGrayMiddle)
                    .onAppear {
                        cartIsEmpty = true
                    }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Cart")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundStyle(.myBlack)
                                .opacity(isScrolling ? 0 : 1)
                                .animation(.easeInOut(duration: 0.3), value: !isScrolling)
                                .padding(.leading)
                            Spacer()
                                .transition(.opacity)
                        }
                        LazyVGrid(columns: layoutForCart, spacing: 16) {
                            ForEach(viewModel.productsInCart, id: \.id) { item in
                                ProductInCartCell(product: item, viewModel: viewModel)
                                
                            }
                            .frame(maxHeight: 300)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).minY) { newValue in
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    scrollOffset = -newValue
                                    isScrolling = newValue < 46
                                }
                            }
                    })
                }
                .onAppear {
                    cartIsEmpty = false
                }
            }
            Spacer()
            Button(action: {
                if cartIsEmpty {
                    dismiss()
                } else {
                    buyIsActive = true
                }
            }) {
                HStack {
                    Text(cartIsEmpty ? "ADD SOMETHING" : "BUY")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(
                            cartIsEmpty ? Color("myBlack") : Color("myWhite"))
                        .padding(.leading, 32)
                    Spacer()
                    Image(.bag)
                        .renderingMode(.template)
                        .foregroundColor(
                            cartIsEmpty ? Color("myBlack") : Color("myWhite"))
                        .padding(.trailing, 32)
                        .frame(maxWidth: 24, maxHeight: 24)
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(cartIsEmpty ? .myWhite : .myBlack)
                .clipShape(RoundedRectangle(cornerRadius: 36))
                .overlay(
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(Color("myBlack"), lineWidth: 1)
                        .shadow(radius: 4)
                )
                .padding(.bottom)
            }
            .padding(.horizontal)
            .alert(isPresented: $buyIsActive) {
                Alert(
                    title: Text("Your Cart"),
                    message: Text(
                        viewModel.productsInCart.map { $0.title }.joined(separator: ", ")),
                    dismissButton: .default(Text("OK")) {
                        viewModel.clearCart()
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Cart")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .opacity(isScrolling ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: isScrolling)
                    }
                    .transition(.opacity)
                }
            }
        }
    }
}
