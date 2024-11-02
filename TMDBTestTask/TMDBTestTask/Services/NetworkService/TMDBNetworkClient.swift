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
    
    func getMovies(page: Int = 1, sort option: String) async throws -> MovieResponse {
        do {
            return try await sendRequest(endpoint: TMDBEndpoint.movies(page: page, sortOption: option),
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
                                         useCache: false,
                                         decoder: decoder)
        } catch {
            throw error
        }
    }
    
    func getMoviewDetail(for id: Int) async throws -> MovieDetail {
        do {
            return try await sendRequest(endpoint: TMDBEndpoint.movieDetail(id: id),
                                         useCache: false,
                                         decoder: decoder)
        } catch {
            throw error
        }
    }
    
    func getMovieVideo(for id: Int) async throws -> VideoRespose {
        do {
            return try await sendRequest(endpoint: TMDBEndpoint.videos(id: id),
                                         useCache: false,
                                         decoder: decoder)
        } catch {
            throw error
        }
    }
    
}
