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
        self.childCoordinators.append(StationDetailCoordinator(self.navigationController))
        self.navigationController.pushViewController(self.mainViewController, animated: true)
    }
    
    func goStationDetail(stationInfo: AroundGasStation) {
        if let stationDetailCoordinator = childCoordinators.first(where: { $0.type == .stationDetail }) as? StationDetailCoordinator {
            stationDetailCoordinator.stationDetailViewController.viewModel?.initData = stationInfo
            stationDetailCoordinator.start()
        }
    }
}
