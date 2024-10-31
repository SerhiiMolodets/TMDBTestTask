//
//  StatusMessage.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//

import Foundation

enum StatusMessage: Error {
    case error(message: String)
    case networkError(message: String)
    case parsError
    case unauthorized
    case unknown(message: String)
}
