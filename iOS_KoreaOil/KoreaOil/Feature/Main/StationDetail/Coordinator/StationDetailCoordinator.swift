//
//  StationDetailCoordinator.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/10/24.
//

import UIKit

class StationDetailCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var stationDetailViewController: StationDetailViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .stationDetail
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.stationDetailViewController = StationDetailViewController()
        self.stationDetailViewController.viewModel = StationDetaionViewModel()
    }
    
    func start() {
        self.navigationController.pushViewController(self.stationDetailViewController, animated: true)
    }
}
