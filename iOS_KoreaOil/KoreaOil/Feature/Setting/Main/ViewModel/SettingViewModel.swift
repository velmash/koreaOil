//
//  SettingViewModel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation

class SettingViewModel: ViewModelType {
    var coordinator: Coordinator
    let defaults = UserDefaults.standard
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func goSourceVC() {
        if let coordinator = coordinator as? SettingViewCoordinator {
            coordinator.goSourceVC()
        }
    }
    
    func setUDValue(type: String, value: String) {
        defaults.setValue(value, forKey: type)
    }
}

extension SettingViewModel {
    struct Input { }
    struct Output { }
}
