//
//  TMDBEndpoint.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//
import Foundation

enum TMDBEndpoint: Endpoint {
    
//    case search(query: String)
    case movies(page: Int)
    case genres
//    case movieDetail(id: Int)
    
    var path: String {
        switch self {
//        case let .search(query: query):
        
        case let .movies:
            return "/3/discover/movie"
//        case let .movieDetail(id: id):
            
        case .genres:
            return "/3/genre/movie/list"
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
        case let .movies(page: page):
            return [URLQueryItem(name: "page", value: String(page))]
        default: return nil
        }
    }
}


//
//https://api.themoviedb.org/3/discover/movie
