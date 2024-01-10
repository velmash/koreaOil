//
//  StationDetaionViewMoel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/10/24.
//

import Foundation

class StationDetaionViewModel: NSObject, ViewModelType {
    var initData: AroundGasStation?
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension StationDetaionViewModel {
    struct Input {
    }
    
    struct Output {
    }
}
