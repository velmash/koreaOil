//
//  OilChartCoordinator.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import UIKit

class OilChartCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var oilChartViewController: OilChartViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .chart
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.oilChartViewController = OilChartViewController()
    }
    
    func start() {
        self.navigationController.pushViewController(self.oilChartViewController, animated: true)
    }
}
