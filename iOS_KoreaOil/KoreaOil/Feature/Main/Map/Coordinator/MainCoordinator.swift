//
//  MainCoordinator.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var mainViewController: MainViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .home
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mainViewController = MainViewController()
        self.mainViewController.viewModel = MainViewModel(coordinator: self)
    }
    
    func start() {
        self.navigationController.pushViewController(self.mainViewController, animated: true)
    }
}
