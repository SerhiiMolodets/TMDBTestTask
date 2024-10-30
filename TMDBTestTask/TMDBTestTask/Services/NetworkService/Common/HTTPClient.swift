//
//  HTTPClient.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        useCache: Bool,
        decoder: JSONDecoder
    ) async throws -> T
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        useCache: Bool = true,
        decoder: JSONDecoder
    ) async throws -> T {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        if useCache {
            if let cachedResponse = URLCache.shared.cachedResponse(for: request),
               let decodedData = try? decoder.decode(T.self, from: cachedResponse.data) {
                return decodedData
            }
        }
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        if let token = endpoint.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let apiKey = endpoint.apiKey {
            request.addValue(apiKey, forHTTPHeaderField: "API-Key")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Failed to decode response data"))
                }
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                return decodedResponse
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
