//
//  DetailViewModel.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//
import Foundation
import Combine
import Dependencies
import UIKit

protocol DetailViewModelProtocol {
    var viewState: AnyPublisher<DetailModel.ViewState, Never> { get }
    var viewAction: AnyPublisher<DetailModel.ViewAction, Never> { get }
    
    func onViewDidLoad()
    func openImageDetail(for image: UIImage)
}

final class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Dependencies -
    @Dependency(\.apiClient) var apiClient
    weak var coordinator: DetailCoordinator?
    
    // MARK: - Properties -
    private let viewStateSubj = CurrentValueSubject<DetailModel.ViewState, Never>(.loading)
    private let viewActionSubj = PassthroughSubject<DetailModel.ViewAction, Never>()
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
}


extension DetailViewModel {
    var viewState: AnyPublisher<DetailModel.ViewState, Never> { viewStateSubj.eraseToAnyPublisher() }
    var viewAction: AnyPublisher<DetailModel.ViewAction, Never> { viewActionSubj.eraseToAnyPublisher() }
    
    func onViewDidLoad() {
        initialLoad()
    }
}

private extension DetailViewModel {
    
    func getMovieDetail() async throws -> MovieDetail {
        do {
            return try await apiClient.getMoviewDetail(for: id)
        } catch {
            throw error
        }
    }
    
    func getVideo() async throws -> VideoResult? {
        do {
            let videoResponse = try await apiClient.getMovieVideo(for: id)
            let video = videoResponse.results.first { $0.type == VideoType.trailer.rawValue && $0.site == VideoSite.youtube.rawValue }
            return video
        } catch {
            throw error
        }
    }
    
    func initialLoad() {
        Task {
            await LoaderView.sharedInstance.start()
            do {
                async let movieDetail = try await getMovieDetail()
                async let video = try await getVideo()
                viewStateSubj.send(.loaded(detail: try await movieDetail, video: try await video))
            } catch {
                viewActionSubj.send(.showError(error))
            }
            await LoaderView.sharedInstance.stop()
        }
    }
}

extension DetailViewModel {
    func openImageDetail(for image: UIImage) {
        coordinator?.openImageDetail(image: image)
    }
}
