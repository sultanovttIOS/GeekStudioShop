//
//  SplashScreenView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 3/9/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    @StateObject private var viewModel = ViewModel()
    @State private var isActive = false
    
    var body: some View {
        VStack {
            if isActive {
                ProductsView()
            } else {
                VStack {
                    Image(.launchScreenLogo)
                        .resizable()
                        .frame(width: 225, height: 116)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    Task {
                        defer {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                withAnimation {
                                    self.isActive = true
                                }
                            }
                        }
                        try await viewModel.fetchProducts()
                        try await viewModel.fetchCategories()
                    }
                }
            }
        }
    }
}
