//
//  SplashScreenView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 3/9/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    @StateObject private var viewModel = ViewModel()
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
                }
                .onAppear {
                    Task {
                        defer {
                            isLoading = false
                        }
                        try await viewModel.fetchProducts()
                        try await viewModel.fetchCategories()
                    }
                }
            } else {
                ProductsView()
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
