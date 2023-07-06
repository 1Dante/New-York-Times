//
//  MainCoordinator.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import Foundation

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let vc = MainViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popToPreviousVC() {
        navigationController.popViewController(animated: true)
    }
}
