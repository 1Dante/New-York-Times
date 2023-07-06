//
//  Coordinator.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
    
}
