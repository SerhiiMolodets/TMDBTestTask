//
//  Endpoint.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var token: String? { get }
    var apiKey: String? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.themoviedb.org"
    }
    
    var token: String? {
        return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNzE3MGU2Y2RiYWE2NDY5NmEzMjI2YTQxNGVhN2Q4ZCIsIm5iZiI6MTczMDMxMjI2Mi41OTIwNjI3LCJzdWIiOiI2MzEwZDUxMGNiODAyODAwODJjYWY1MjMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0._BR0jRaCJ13rg60rDn19TG97SWYXiqyCOuFE-kLi_tI"
    }
    
    var apiKey: String? {
        return nil
    }
}
