//
//  ViewController.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import UIKit
import Combine
import UIScrollView_InfiniteScroll

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
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: String(describing: MainTableViewCell.self))
        return tableView
    }()
    private let refreshControl = UIRefreshControl()
    
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
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        refreshControl.tintColor = .black
        refreshControl.addTarget(viewModel, action: #selector(MainViewModel.refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
//        tableView.addInfiniteScroll { [weak self] _ in
//            self?.viewModel.fetch(reload: false, nextPage: true)
//        }
//        
//        tableView.setShouldShowInfiniteScrollHandler { [weak self] _ in
//            return self?.viewModel.canPaginate() == true
//        }
        
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
        navigationItem.hidesSearchBarWhenScrolling = false
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
        case .loaded:
            tableView.reloadData()
            refreshControl.endRefreshing()
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
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainTableViewCell.self), for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        let item = viewModel.items[indexPath.row]
        cell.set(item: item)
        let genres = viewModel.getGenresTitles(by: item.genreIds ?? [])
        cell.setGenres(titles: genres)
        return cell
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
          let scrollViewHeight = scrollView.frame.size.height
          let offset = scrollView.contentOffset.y
          let threshold: CGFloat = 100

          if offset > contentHeight - scrollViewHeight - threshold {
              self.viewModel.fetch(reload: false, nextPage: true)
          }
    }
}
