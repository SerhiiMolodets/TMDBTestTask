//
//  AppCoordinator.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//
import UIKit

final class AppCoordinator: AppCoordinatorProtocol {
    let window: UIWindow
    weak var parentCoordinator: Coordinator?
    var childrenCoordinator: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        openMain()
    }
    
    func openMain() {
        let coordinator = MainCoordinator(navigationController: UINavigationController())
        window.rootViewController = coordinator.navigationController
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}
