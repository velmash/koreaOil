//
//  SourceViewCoordinator.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/13/23.
//

import UIKit

class SourceViewCoordinator: Coordinator {
    var navigationController: UINavigationController
    var sourceViewController: SourceViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .source
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.sourceViewController = SourceViewController()
        self.sourceViewController.viewModel = SourceViewModel(coordinator: self)
    }
    
    func start() {
        self.navigationController.pushViewController(self.sourceViewController, animated: true)
    }
    
    func goBack() {
        self.navigationController.popViewController(animated: true)
    }
}
