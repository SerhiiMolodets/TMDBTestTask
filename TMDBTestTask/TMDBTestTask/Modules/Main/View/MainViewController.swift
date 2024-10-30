//
//  ViewController.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
        setupSubscriptions()
    }
    
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
    
    func renderState(_ state: MainModel.ViewState) {
        switch state {
        case let .loaded(items, animated):
            print(items)
        // reload
        case .empty:
            break // show empty state
        case .loading:
            break // show loading state
        }

    }
    
    func handleAction(_ action: MainModel.ViewAction) {
//        switch action {
//        case .showNotImplementedAlert:
//            showToast(message: "Not Implemented", .error)
//        case let .showError(error):
//            handleStatusMessage(error)
//        case .showAddButton(let isHidden):
//            addButton.isHidden = isHidden
//        }
    }
}

