//
//  MainModel.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

struct MainModel {
    // MARK: Output
    enum ViewState: Equatable {
        case empty
        case loaded
    }
    
    enum ViewAction {
        case showError(Error)
    }
}
