//
//  DetailViewController.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    // MARK: - Properties -
    private var cancellables = Set<AnyCancellable>()
    var viewModel: DetailViewModelProtocol
    
    // MARK: - Views -
    private let posterView = UIImageView()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubscriptions()
        viewModel.onViewDidLoad()
    }
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Subscriptions
private extension DetailViewController {
    func setupSubscriptions() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.renderState(state)
            }
            .store(in: &cancellables)
        
        viewModel.viewAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.handleAction(action)
            }
            .store(in: &cancellables)
        
    }
    
    func renderState(_ state: DetailModel.ViewState) {
        switch state {
        case let .loaded(detail, video):
            print(detail)
            print(video)
        case .loading:
            break
        }
        
    }
    
    func handleAction(_ action: DetailModel.ViewAction) {
                switch action {
                case let .showError(error):
                    showAlert(error.localizedDescription)
                }
    }
}
