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
    
    func getMovies(page: Int = 1) async throws -> MovieResponse {
        do {
            return try await sendRequest(endpoint: TMDBEndpoint.movies(page: page),
                                         useCache: true,
                                         decoder: decoder)
        } catch {
            throw error
        }
    }
    
    func getGenres() async throws -> GenresResponse {
        do {
            return try await sendRequest(endpoint: TMDBEndpoint.genres,
                                         useCache: true,
                                         decoder: decoder)
        } catch {
            throw error
        }
    }
    
    func searchMovies(query: String) async throws -> MovieResponse {
        do {
            return try await sendRequest(endpoint: TMDBEndpoint.search(query: query),
                                         useCache: true,
                                         decoder: decoder)
        } catch {
            throw error
        }
    }
}
