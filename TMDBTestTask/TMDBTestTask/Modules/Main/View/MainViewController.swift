//
//  ViewController.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    // MARK: - Views -
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
    
    private let dataPlaceholderView: EmptyDataPlaceholderView = {
        let view = EmptyDataPlaceholderView()
        view.isHidden = true
        return view
    }()
    // MARK: - Viewmodel -
    private var viewModel: MainViewModelProtocol
    
    // MARK: - Properties -
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle -
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
        setupSubscriptions()
        setupUI()
    }
}


private extension MainViewController {
    
    // MARK: - Setup Methods -
    func setupUI() {
        setupNavigationBar()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(dataPlaceholderView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dataPlaceholderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        refreshControl.tintColor = .black
        refreshControl.addTarget(viewModel, action: #selector(MainViewModel.refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupNavigationBar() {
        navigationItem.title = "main_navbar_title".localized()
        navigationItem.backButtonDisplayMode = .minimal
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.up.and.down.text.horizontal")?.withTintColor(.gray), for: .normal)
        button.frame = CGRectMake(0, 0, 44, 44)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(sortedAction), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.navigationBar.tintColor = .black
        
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = "common_search".localized()
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Actions -
    @objc private func sortedAction() {
        let actionSheet = UIAlertController(title: "main_sort_option_title".localized(), message: "main_sort_option_message".localized(), preferredStyle: .actionSheet)
        
        let options: [SortOption] = [.alphabetical, .date, .rating]
        for option in options {
            let action = UIAlertAction(title: option.rawValue.localized(), style: .default) { [weak self] _ in
                self?.viewModel.selectedSortOption = option
            }
            
            if option == viewModel.selectedSortOption {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "common_cancel".localized(), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
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
            dataPlaceholderView.isHidden = true
            tableView.reloadData()
            refreshControl.endRefreshing()
        case .empty:
            dataPlaceholderView.isHidden = false
            tableView.reloadData()
        }
        
    }
    
    func handleAction(_ action: MainModel.ViewAction) {
                switch action {
                case let .showError(error):
                    showAlert(error.localizedDescription)
                case let .showMessage(message):
                    showAlert(message)
                }
    }
}

// MARK: - UISearchControllerDelegate -
extension MainViewController: UISearchControllerDelegate { }


// MARK: - UISearchBarDelegate -
extension MainViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = ""
        navigationItem.searchController?.searchBar.text = ""
    }
}

// MARK: - UISearchResultsUpdating -
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchQuery = searchController.searchBar.text ?? ""
    }
}

// MARK: - UITableViewDataSource -
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

// MARK: - UITableViewDelegate -
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}
