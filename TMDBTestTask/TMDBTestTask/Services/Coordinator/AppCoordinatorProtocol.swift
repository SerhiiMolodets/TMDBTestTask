//
//  AppCoordinatorProtocol.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    var window: UIWindow { get }
    func openMain()
}
