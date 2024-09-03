//
//  RatingView.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 3/9/24.
//

import SwiftUI

struct RatingView: View {
    let rating: Float
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                Image(rating > Float(index) ? "starFill" : "star")
                    .font(.system(size: 16))
            }
        }
    }
}

#Preview {
    RatingView(rating: 3)
}
