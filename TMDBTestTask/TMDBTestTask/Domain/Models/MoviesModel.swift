//
//  Movies.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import Foundation

// MARK: - MovieResponse
struct MovieResponse: Codable, Equatable {
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?
}

// MARK: - Result
struct MovieResult: Codable, Equatable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}

// MARK: - GenresResponse
struct GenresResponse: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
    
    func check(id: Int) -> String? {
        id == self.id ? name : nil
    }
}
