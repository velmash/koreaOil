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
    private var phoneNum: String?
    
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
            .withUnretained(self)
            .subscribeNext { owner, data in
                let parsingData = data.value.result.oil.first
                owner.phoneNum = parsingData?.phoneNum
                print("테스트 진행중: ", parsingData?.isMaint)
            }
            .disposed(by: bag)
    }
    
    func callStation() {
        if let num = self.phoneNum, let callUrl = URL(string: "tel://\(num))") {
            UIApplication.shared.open(callUrl, options: [:], completionHandler: nil)
        } else {
            iToast.show("전화 기능을 사용할 수 없습니다.")
        }
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
