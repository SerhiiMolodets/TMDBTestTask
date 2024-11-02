//
//  TMDBEndpoint.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//
import Foundation

enum TMDBEndpoint: Endpoint {
    
    case search(query: String)
    case movies(page: Int, sortOption: String)
    case genres
    case movieDetail(id: Int)
    case videos(id: Int)
    
    var path: String {
        switch self {
        case .search:
            return "/3/search/movie"
        case .movies:
            return "/3/discover/movie"
        case let .movieDetail(id):
            return "/3/movie/\(id)"
        case .genres:
            return "/3/genre/movie/list"
        case let .videos(id):
            return "/3/movie/\(id)/videos"
        }
    }

    var method: RequestMethod {
        return .get
    }
    
    var header: [String: String]? {
        return nil
    }
    var body: [String: String]? {
        return nil
    }
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .movies(page: page, sortOption: sortOption):
            return [URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "sort_by", value: String(sortOption))]
        case let .search(query: query):
            return [URLQueryItem(name: "query", value: query)]
        default: return nil
        }
    }
}


//
//https://api.themoviedb.org/3/discover/movie
