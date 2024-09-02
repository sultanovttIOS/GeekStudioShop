//
//  NetworkService.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import Foundation
import Alamofire
import SwiftUI

final class NetworkService {
    static let shared = NetworkService()
    
    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 15
        return session
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    
    private let baseURL = "https://fakestoreapi.com/"
    private let imageCache = NSCache<NSString, UIImage>()
    
    func getAllProducts(category: String?, limit: Int) async throws -> [Product] {
        guard var url = URL(string: baseURL) else {
            throw APIError.invalidServerURL
        }
        
        url.append(path: "products")
        if let category {
            url.append(path: "category/\(category)")
        }
        
        url.append(queryItems: [URLQueryItem( name: "limit", value: "\(limit)")])
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [Product].self, decoder: decoder) { response in
                    print("******************")

                    print(url)
                    switch response.result {
                    case .success(let products):
                        continuation.resume(returning: products)
                    case .failure(let error):
                        handleAlamofireError(
                            error,
                            data: response.data,
                            response: response.response,
                            continuation: continuation)
                    }
                }
            
            func handleAlamofireError(
                _ error: AFError,
                data: Data?,
                response: HTTPURLResponse?,
                continuation: CheckedContinuation<[Product], Error>
            ) {
                if let data = data, let serverMessage = String(data: data, encoding: .utf8) {
                    print("Server Error: \(serverMessage)")
                }
                continuation.resume(throwing: error)
            }
        }
    }

    func getCategories() async throws -> [String] {
        guard var url = URL(string: baseURL) else {
            throw APIError.invalidServerURL
        }
        
        url.append(path: "products/categories")
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [String].self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let categories):
                        continuation.resume(returning: categories)
                    case .failure(let error):
                        self.handleAlamofireError(
                            error,
                            data: response.data,
                            response: response.response,
                            continuation: continuation)
                    }
                }
        }
    }

    func handleAlamofireError(
        _ error: AFError,
        data: Data?,
        response: HTTPURLResponse?,
        continuation: CheckedContinuation<[String], Error>
    ) {
        if let data = data, let serverMessage = String(data: data, encoding: .utf8) {
            print("Server Error: \(serverMessage)")
        }
        continuation.resume(throwing: error)
    }
    
    func getImage(from url: URL) async -> Image? {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return Image(uiImage: cachedImage)
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: cacheKey)
                return Image(uiImage: image)
            }
        } catch {
            print("Error loading image: \(error)")
        }
        
        return nil
    }
}
