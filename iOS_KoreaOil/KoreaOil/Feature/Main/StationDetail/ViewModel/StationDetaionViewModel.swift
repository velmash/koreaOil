//
//  StationDetaionViewMoel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/10/24.
//

import Foundation

class StationDetaionViewModel: NSObject, ViewModelType {
    var initData: AroundGasStation?
    
    var coordinator: StationDetailCoordinator
    
    init(coordinator: StationDetailCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func goBack() {
        if let coordinator = coordinator as? StationDetailCoordinator {
            coordinator.goBack()
        }
    }
}

extension StationDetaionViewModel {
    struct Input {
    }
    
    struct Output {
    }
}
