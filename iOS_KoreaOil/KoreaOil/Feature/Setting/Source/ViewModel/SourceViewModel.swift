//
//  SourceViewModel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/13/23.
//

import Foundation

class SourceViewModel: ViewModelType {
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func goBack() {
        if let coordinator = coordinator as? SourceViewCoordinator {
            coordinator.goBack()
        }
    }
}

extension SourceViewModel {
    struct Input { }
    struct Output { }
}
