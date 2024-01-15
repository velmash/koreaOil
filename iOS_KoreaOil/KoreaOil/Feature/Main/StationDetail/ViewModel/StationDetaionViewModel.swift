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
    
    private let stationDetailInfoRelay = BehaviorRelay<StationDetailInfo?>(value: nil)
    
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
        Driver.merge(
            input.goBackBtnTap.map { _ in InputBtnType.goBack },
            input.callBtnTap.map { _ in InputBtnType.call },
            input.stopoverBtnTap.map { _ in InputBtnType.routeType(.stopover) },
            input.destBtnTap.map { _ in InputBtnType.routeType(.dest) }
        )
        .throttle(.milliseconds(500), latest: false)
        .driveNext { [weak self] type in
            switch type {
            case .goBack:
                self?.goBack()
            case .call:
                self?.callStation()
            case .routeType(.stopover):
                self?.stopoverMap()
            case .routeType(.dest):
                self?.destMap()
            }
        }
        .disposed(by: bag)
        
        let stationDetailInfoPost = stationDetailInfoRelay.compactMap { $0 }.asObservable().asDriverOnErrorJustComplete()
        
        return Output(stationDetailInfoPost: stationDetailInfoPost)
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
                owner.stationDetailInfoRelay.accept(parsingData)
            }
            .disposed(by: bag)
    }
    
    private func goBack() {
        coordinator.goBack()
    }
    
    private func callStation() {
        if let num = self.stationDetailInfoRelay.value?.phoneNum,
           let callUrl = URL(string: "tel://\(num))") {
            UIApplication.shared.open(callUrl, options: [:], completionHandler: nil)
        } else {
            iToast.show("전화 기능을 사용할 수 없습니다.")
        }
    }
    
    private func stopoverMap() {
        iToast.show("구현해라 123")
    }
    
    private func destMap() {
        iToast.show("구현해라 456")
    }
}

extension StationDetaionViewModel {
    struct Input {
        let goBackBtnTap: Driver<Void>
        let callBtnTap: Driver<Void>
        let stopoverBtnTap: Driver<Void>
        let destBtnTap: Driver<Void>
    }
    
    struct Output {
        let stationDetailInfoPost: Driver<StationDetailInfo>
    }
    
    private enum InputBtnType {
        case goBack
        case call
        case routeType(RouteType)

        enum RouteType {
            case stopover
            case dest
        }
    }

}
