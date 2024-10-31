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
        case loading
        case loaded
    }
    
    enum ViewAction {
        case showError(Error)
//        case showError(StatusMessage)
//        case showAddButton(isHidden: Bool)
    }
}
