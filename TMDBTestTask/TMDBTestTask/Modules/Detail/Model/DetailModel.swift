//
//  DetailModel.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//

import Foundation

struct DetailModel {
    // MARK: Output
    enum ViewState {
        case loaded(detail: MovieDetail, video: VideoResult?)
        case loading
    }
    
    enum ViewAction {
        case showError(Error)
    }
}
