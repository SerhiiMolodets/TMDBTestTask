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
        openMainViewController()
    }
    
    func openMainViewController() {
//        let viewModel // build vm
        let viewController = MainViewController()
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
