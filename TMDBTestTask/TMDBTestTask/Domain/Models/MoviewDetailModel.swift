//
//  MoviewDetailModel.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 01.11.2024.
//

import Foundation

// MARK: - MovieDetail
struct MovieDetail: Codable {
    let genres: [Genre]?
    let id: Int
    let originCountry: [String]?
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool?
    let voteAverage: Double?
    let overview: String?
}

// MARK: - VideoRespose
struct VideoRespose: Codable {
    let id: Int
    let results: [VideoResult]
}

// MARK: - Result
struct VideoResult: Codable {
let name, key: String?
    let publishedAt, site: String?
    let size: Int?
    let type: String?
    let id: String?
}

enum VideoSite: String {
    case youtube = "YouTube"
}

enum VideoType: String {
    case trailer = "Trailer"
}
