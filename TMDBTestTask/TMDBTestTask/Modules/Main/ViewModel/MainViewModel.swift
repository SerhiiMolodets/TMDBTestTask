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
    var items: [MovieResult] = []
    var genres: [Genre] = []
    
    private var netwrok = TMDBNetworkClient()
    
}


extension MainViewModel {
    var viewState: AnyPublisher<MainModel.ViewState, Never> { viewStateSubj.eraseToAnyPublisher() }
    var viewAction: AnyPublisher<MainModel.ViewAction, Never> { viewActionSubj.eraseToAnyPublisher() }
    
    @MainActor
    func onViewDidLoad() {
        LoaderView.sharedInstance.start()
        fetch(reload: false, nextPage: false)
        getGenres()
    }
    
    @MainActor
    func fetch(reload: Bool, nextPage: Bool) {
        guard !isLoading else { return }
        if canPaginate()  {
            currentPage += 1
        }
        
        if currentPage <= 1 || reload {
            self.currentPage = 1
            self.totalPages = 0
        }
        
        
        if reload { isPaginated = false }
        else if currentPage > 1 { isPaginated = true }
        
        
        Task {
            do {
                isLoading = true
                let moviesResponse = try await netwrok.getMoviews(page: currentPage)
                currentPage = moviesResponse.page ?? 0
                totalPages = moviesResponse.totalPages ?? 0
                
                proceed(movies: moviesResponse.results ?? [], nextPage: nextPage)
            } catch {
                debugPrint(error)
            }
            isLoading = false
        }
        
    }
    
    @MainActor
    private func getGenres() {
        Task {
            do {
                genres = try await netwrok.getGenres().genres
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func proceed(movies: [MovieResult], nextPage: Bool) {
        var items: [MovieResult] = []
        if nextPage { items += self.items }
        items.append(contentsOf: movies)
        if items.isEmpty { viewStateSubj.send(.empty) }
        else { viewStateSubj.send(.loaded) }
        self.items = items
        LoaderView.sharedInstance.stop()
    }
    
    func canPaginate() -> Bool {
        return self.currentPage < self.totalPages
    }
    
    @MainActor
    @objc func refresh() {
        fetch(reload: true, nextPage: false)
    }
    
    func getGenresTitles(by ids: [Int]) -> String {
        var titles = ""
        ids.forEach { id in
            if let genre = genres.first(where: { genre in
                return id == genre.id
            }) {
                titles.append("\(genre.name) ")
            }
        }
        return titles
    }
}
