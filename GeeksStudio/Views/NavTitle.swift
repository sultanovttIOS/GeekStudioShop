//
//  NavTitle.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 5/9/24.
//

import SwiftUI

struct NavTitle: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .foregroundStyle(.black)
            Text(subtitle)
                .font(.title3)
                .foregroundStyle(.black)
        }
        
    }
}

#Preview {
    NavTitle(title: "Products", subtitle: "All")
}
