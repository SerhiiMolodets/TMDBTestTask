//
//  MainViewModel.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import Foundation
import Combine

final class MainViewModel {
    private let viewStateSubj = CurrentValueSubject<MainModel.ViewState, Never>(.loading)
    private let viewActionSubj = PassthroughSubject<MainModel.ViewAction, Never>()
    
    
    private var isLoading = false
    private var isPaginated = false
    private var currentPage = 0
    private var totalPages = 0
    
    
    private var netwrok = TMDBNetworkClient()
    
}


extension MainViewModel {
    var viewState: AnyPublisher<MainModel.ViewState, Never> { viewStateSubj.eraseToAnyPublisher() }
    var viewAction: AnyPublisher<MainModel.ViewAction, Never> { viewActionSubj.eraseToAnyPublisher() }
    
    @MainActor
    func onViewDidLoad() {
                fetch(reload: false, nextPage: false)
    }
    
    func items() -> [MovieResult] {
        switch viewStateSubj.value {
        case let .loaded(items, _): return items
        default: return []
        }
    }
    
    @MainActor
    func fetch(reload: Bool, nextPage: Bool) {
        
        if canPaginate()  {
            currentPage += 1
        }
        
        if currentPage <= 1 || reload {
            self.currentPage = 0
            self.totalPages = 0
        }
        
        guard !isLoading else { return }
        if reload { isPaginated = false }
        else if currentPage > 1 { isPaginated = true }
        isLoading = true
        
        Task {
            do {
                let moviesResponse = try await netwrok.getMoviews(page: 0)
                currentPage = moviesResponse.page ?? 0
                totalPages = moviesResponse.totalPages ?? 0
                
                proceed(movies: moviesResponse.results ?? [], nextPage: nextPage)
            } catch {
                debugPrint(error)
            }
        }

//        dependencies.notificationManager.getNotifications(page: currentPage) { [weak self] result in
//            switch result {
//            case .success(let response):
//                self?.currentPage = response.current_page ?? 0
//                self?.totalPages = response.total_pages ?? 0
//                self?.proceed(notifications: response.items, nextPage: nextPage)
//            case .failure(let message):
//                self?.viewActionSubj.send(.showError(message))
//            }
//            self?.isLoading = false
//        }
        
    }
    
    func proceed(movies: [MovieResult], nextPage: Bool) {
        var items: [MovieResult] = []
        
        if nextPage { items += self.items() }
        
        items.append(contentsOf: movies)
        
        if items.isEmpty { viewStateSubj.send(.empty) }
        else { viewStateSubj.send(.loaded(items, true)) }
    }
    
    func canPaginate() -> Bool {
        return self.currentPage < self.totalPages
    }
}
