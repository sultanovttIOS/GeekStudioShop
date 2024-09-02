//
//  Categories.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import Foundation

struct Category: Decodable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "category"
    }
}
