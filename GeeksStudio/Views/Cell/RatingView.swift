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
                if index < Int(rating) {
                    Image("starFill")
                        .font(.system(size: 16))
                } else if index == Int(
                    rating) && rating.truncatingRemainder(
                        dividingBy: 1) >= 0.5 {
                    Image("starHalf")
                        .font(.system(size: 16))
                } else {
                    Image("star")
                        .font(.system(size: 16))
                }
            }
        }
    }
}
