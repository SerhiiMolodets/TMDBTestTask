//
//  DetailCoordinator.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//

import UIKit

final class DetailCoordinator: Coordinator {
    
    
    weak var parentCoordinator: Coordinator?
    var childrenCoordinator: [Coordinator] = []
    let navigationController: UINavigationController
    let id: Int
    
    init(navigationController: UINavigationController, id: Int) {
        self.navigationController = navigationController
        self.id = id
    }
    
    func start() {
        openDetail(id: id)
    }
    
    func openDetail(id: Int) {
        let viewModel = DetailViewModel(id: id)
        viewModel.coordinator = self
        let viewController = DetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
