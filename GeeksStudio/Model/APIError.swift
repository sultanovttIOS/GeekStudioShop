//
//  APIError.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 2/9/24.
//

import Foundation

enum APIError: Error {
    case invalidServerURL
    case notHTTPResponse
    case unexpectedStatusCode
    case decodingError
}
