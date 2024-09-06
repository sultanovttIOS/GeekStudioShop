//
//  CategoriesView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 2/9/24.
//

import SwiftUI

struct CategoryMenu: View {
    @StateObject var viewModel: ViewModel
    var onSelectCategory: (String) -> Void
    let layoutForMenu = [GridItem(.adaptive(minimum: screen.width / 1))]
    @State private var selectedCategory: String? = "All"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Categories")
                .padding(.top, 8)
                .padding(.horizontal)
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(Color(.myBlack))
                .cornerRadius(12)
            Text("Indicate your preferences")
                .padding(.horizontal)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color(.myGrayDark))
                .padding(.bottom, 8)
            
            BigDivider()
            
            List(viewModel.categories, id: \.self) { category in
                HStack {
                    Text(category)
                        .padding(.horizontal)
                        .frame(alignment: .leading)
                    Spacer()
                    if viewModel.selectedCategory == category {
                        Image(.check)
                            .padding(.horizontal)
                            .foregroundColor(.myBlack)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCategory = category
                    viewModel.selectedCategory = category
                    onSelectCategory(category)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color(.myGrayLight))
            }
            .listStyle(PlainListStyle())
            .scrollDisabled(true)
            .foregroundColor(Color(.myBlack))
            .background(Color(.myGrayLight))
        }
        .frame(maxWidth: 248, maxHeight: 290)
        .background(Color(.myWhite))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct BigDivider: View {
    var body: some View {
        Divider()
            .frame(height: 6)
            .background(Color(.myGrayAverage))
    }
}


