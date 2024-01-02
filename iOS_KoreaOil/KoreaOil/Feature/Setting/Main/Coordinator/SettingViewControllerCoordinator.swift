//
//  SettingCoordinator.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import UIKit

class SettingViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var settingViewController: SettingViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .setting
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.settingViewController = SettingViewController()
        self.settingViewController.viewModel = SettingViewModel(coordinator: self)
    }
    
    func start() {
        self.navigationController.pushViewController(self.settingViewController, animated: true)
        
        let sourceCoor = SourceViewCoordinator(self.navigationController)
        self.childCoordinators.append(sourceCoor)
    }
    
    func goSourceVC() {
        self.findCoordinator(type: .source)?.start()
    }
}
