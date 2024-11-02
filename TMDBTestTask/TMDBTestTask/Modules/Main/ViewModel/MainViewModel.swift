//
//  MainViewModel.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import Foundation
import Combine
import Dependencies

// MARK: - MainViewModelProtocol -
protocol MainViewModelProtocol {
    var selectedSortOption: SortOption { get set }
    var viewState: AnyPublisher<MainModel.ViewState, Never> { get }
    var viewAction: AnyPublisher<MainModel.ViewAction, Never> { get }
    var searchQuery: String { get set }
    var items: [MovieResult] { get set }
    
    func onViewDidLoad()
    func getGenresTitles(by ids: [Int]) -> String
    func fetch(reload: Bool, nextPage: Bool)
    func didSelectItem(at indexPath: IndexPath)
}

// MARK: - MainViewModel -
final class MainViewModel: @preconcurrency MainViewModelProtocol {
    
    // MARK: - Dependencies -
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.networkMonitor) var networkMonitor
    
    // MARK: - Properties -
    private let viewStateSubj = CurrentValueSubject<MainModel.ViewState, Never>(.empty)
    private let viewActionSubj = PassthroughSubject<MainModel.ViewAction, Never>()
    private var isLoading = false
    private var isPaginated = false
    private var currentPage = 0
    private var totalPages = 0
    var items: [MovieResult] = []
    var genres: [Genre] = []
    var selectedSortOption: SortOption = .rating {
        didSet {
                    sortItems()
        }
    }
    @Published var searchQuery: String = ""
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: MainCoordinator?
}

extension MainViewModel {
    var viewState: AnyPublisher<MainModel.ViewState, Never> { viewStateSubj.eraseToAnyPublisher() }
    var viewAction: AnyPublisher<MainModel.ViewAction, Never> { viewActionSubj.eraseToAnyPublisher() }
    
    @MainActor
    func onViewDidLoad() {
        LoaderView.sharedInstance.start()
        fetch(reload: false, nextPage: false)
        getGenres()
        setupSearchBinding()
        monitorNetworkStatus()
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
                let moviesResponse = try await apiClient.getMovies(page: currentPage, sort: selectedSortOption.networkValue)
                currentPage = moviesResponse.page ?? 0
                totalPages = moviesResponse.totalPages ?? 0
                
                proceed(movies: moviesResponse.results ?? [], nextPage: nextPage)
            } catch {
                viewActionSubj.send(.showError(error))
            }
            isLoading = false
        }
    }
    
    func canPaginate() -> Bool {
        return self.currentPage < self.totalPages
    }
    
    @MainActor
    @objc func refresh() {
        guard checkConnection() else { return }
        fetch(reload: true, nextPage: false)
        searchQuery = ""
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
    
    func didSelectItem(at indexPath: IndexPath) {
        guard checkConnection() else { return }
        let item = items[indexPath.row]
        coordinator?.openDetails(id: item.id ?? 0)
    }
}


private extension MainViewModel {
    func sortItems() {
        guard checkConnection() else { return }
        Task { @MainActor in
            LoaderView.sharedInstance.start()
            fetch(reload: true, nextPage: false)
            LoaderView.sharedInstance.stop()
        }
    }

    @MainActor
    private func setupSearchBinding() {
        $searchQuery
            .debounce(for: .milliseconds(600), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard !query.isEmpty else { return }
                self?.search(query: query, reload: true, nextPage: false)
            }
            .store(in: &cancellables)
    }
    
    private func getGenres() {
        Task {
            do {
                genres = try await apiClient.getGenres().genres
            } catch {
                viewActionSubj.send(.showError(error))
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
    
    @MainActor
    func search(query: String, reload: Bool, nextPage: Bool) {
        if networkMonitor.isConnected {
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
                    let moviesResponse = try await apiClient.searchMovies(query: query)
                    currentPage = moviesResponse.page ?? 0
                    totalPages = moviesResponse.totalPages ?? 0
                    
                    proceed(movies: moviesResponse.results ?? [], nextPage: nextPage)
                } catch {
                    viewActionSubj.send(.showError(error))
                }
                isLoading = false
            }
        } else {
            let filteredMovies = items.filter { $0.title?.lowercased().contains(query.lowercased()) ?? false }
            proceed(movies: filteredMovies, nextPage: false)
        }
    }
    
    func monitorNetworkStatus() {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard !isConnected else { return }
                self?.viewActionSubj.send(.showMessage("connection_error_message".localized()))
            }
            .store(in: &cancellables)
    }
    
    func checkConnection() -> Bool {
        if networkMonitor.isConnected {
            return true
        } else {
            viewActionSubj.send(.showMessage("connection_error_message".localized()))
            return false
        }
    }
}
