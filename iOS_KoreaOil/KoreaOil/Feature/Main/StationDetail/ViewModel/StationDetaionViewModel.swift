//
//  StationDetaionViewMoel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/10/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class StationDetaionViewModel: NSObject, ViewModelType {
    private let useCase = MainSceneUseCase()
    private var bag = DisposeBag()
    
    var initData: AroundGasStation? {
        didSet {
            self.getStationDetailInfo()
        }
    }
    
    var coordinator: StationDetailCoordinator
    
    init(coordinator: StationDetailCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    private func getStationDetailInfo() {
        guard let initData = initData else { return }
        
        var param = Parameters()
        param["code"] = ApiKey().free
        param["out"] = "json"
        param["id"] = initData.stationId
        
        useCase.getStationDetailInfo(param)
            .subscribeNext { data in
                let parsingData = data.value.result.oil
                print("테스트 진행중: ", parsingData)
            }
            .disposed(by: bag)
    }
    
    func goBack() {
        coordinator.goBack()
    }
}

extension StationDetaionViewModel {
    struct Input {
    }
    
    struct Output {
    }
}
