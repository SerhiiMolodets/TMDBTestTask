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
        
    private lazy var tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.showsVerticalScrollIndicator = false
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.dataSource = self
            tableView.delegate = self
//            tableView.register(VisitedCountriesDetailTableViewCell.self, forCellReuseIdentifier: VisitedCountriesDetailTableViewCell.className)
//            tableView.register(TravelsTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: TravelsTableViewSectionHeader.className)
    //        tableView.register(VisitedCountriesDetailTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: VisitedCountriesDetailTableViewSectionHeader.className)
            return tableView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
        setupSubscriptions()
        setupUI()
    }
    

}


private extension MainViewController {
    func setupUI() {
        setupNavigationBar()
        view.backgroundColor = .white
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Popular Movies" // localize
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.up.and.down.text.horizontal")?.withTintColor(.gray), for: .normal)
        button.frame = CGRectMake(0, 0, 44, 44)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(sortedAction), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .gray
        
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        
        navigationItem.searchController = search
    }
    
 @objc private func sortedAction() {
        
    }
}


// MARK: - Subscriptions
private extension MainViewController {
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

extension MainViewController: UISearchControllerDelegate {
    
}

extension MainViewController: UISearchBarDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    
}
