//
//  RegionCoordinator.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import UIKit

class RegionCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var regionViewController: RegionViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .region
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.regionViewController = RegionViewController()
        self.regionViewController.viewModel = RegionViewModel(coordinator: self)
    }
    
    func start() {
        self.navigationController.pushViewController(self.regionViewController, animated: true)
    }
}
