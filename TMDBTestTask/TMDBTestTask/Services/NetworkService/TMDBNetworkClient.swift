//
//  TMDBNetworkClient.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//
import Foundation

struct TMDBNetworkClient: HTTPClient {
    private let decoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        return $0
    }(JSONDecoder())
    
    func getMoviews(page: Int = 1) async throws -> MovieResponse {
        do {
            return try await sendRequest(endpoint: TMDBEndpoint.movies(page: page),
                                         useCache: true,
                                         decoder: decoder)
        } catch {
            throw error
        }
    }
}
