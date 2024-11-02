//
//  SortOption.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//

import Foundation

enum SortOption:  String {
    case alphabetical = "main_alphabetical_sort_option"
     case date = "main_date_sort_option"
     case rating = "main_rating_sort_option"
    
    var networkValue: String {
        switch self {
            case .alphabetical: return "title.asc"
        case .date: return "primary_release_date.desc"
        case .rating: return "popularity.desc"
        }
    }
 }
