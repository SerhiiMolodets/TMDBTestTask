//
//  MainCoordinator.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var childrenCoordinator: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        openMain()
    }
    
    func openMain() {
        let viewModel = MainViewModel()
        viewModel.coordinator = self
        let viewController = MainViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func openDetails(id: Int) {
        let coordinator = DetailCoordinator(navigationController: navigationController, id: id)
        coordinator.parentCoordinator = self
        childrenCoordinator.append(coordinator)
        coordinator.start()
    }
}
