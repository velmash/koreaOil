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
import NMapsMap
import KakaoSDKNavi
import TMapSDK

class StationDetaionViewModel: NSObject, ViewModelType {
    let defaults = UserDefaults.standard
    private var coordinator: StationDetailCoordinator
    private let geoConverter = GeoConverter()
    
    private var bag = DisposeBag()
    private let useCase = MainSceneUseCase()
    
    private let stationDetailInfoRelay = BehaviorRelay<StationDetailInfo?>(value: nil)
    
    var initData: AroundGasStation? {
        didSet {
            self.getStationDetailInfo()
        }
    }
    
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
        let naviType = NaviType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDNaviType )}) ?? .tmap
        guard let statioinInfo = stationDetailInfoRelay.value else { return }
        let convertedWGSPoint = geoConverter.convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: GeographicPoint(x: statioinInfo.x, y: statioinInfo.y))
        
        if naviType == .naver {
            let urlStr = "nmap://route/car?dlat=\(convertedWGSPoint?.y ?? 0)&dlng=\(convertedWGSPoint?.x ?? 0)&dname=도착지 직접입력&v1lat=\(convertedWGSPoint?.y ?? 0)&v1lng=\(convertedWGSPoint?.x ?? 0)&v1name=\(statioinInfo.brandName)"
            guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            guard let url = URL(string: encodedStr) else { return }
            let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.open(appStoreURL)
            }
        } else if naviType == .tmap {
            let routeInfo = [
                "rGoName":"도착지 직접입력",
                "rGoX" : convertedWGSPoint?.x ?? 0,
                "rGoY" : convertedWGSPoint?.y ?? 0,
                "rV1Name" : statioinInfo.brandName,
                "rV1X" : convertedWGSPoint?.x ?? 0,
                "rV1Y" : convertedWGSPoint?.y ?? 0] as [String : Any]
            
            _ = TMapApi.invokeRoute(routeInfo)
        } else if naviType == .kakao {
            let destination = NaviLocation(name: "도착지 직접입력", x: "\(Int64(statioinInfo.x) + 10)", y: "\(Int64(statioinInfo.y) + 10)")
            let viaList = [NaviLocation(name: "\(statioinInfo.brandName)",  x: "\(Int64(statioinInfo.x))", y: "\(Int64(statioinInfo.y))")]
            guard let navigateUrl = NaviApi.shared.shareUrl(destination: destination, viaList: viaList) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(navigateUrl) {
                UIApplication.shared.open(navigateUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(NaviApi.webNaviInstallUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func destMap() {
        let naviType = NaviType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDNaviType )}) ?? .tmap
        guard let statioinInfo = stationDetailInfoRelay.value else { return }
        let convertedWGSPoint = geoConverter.convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: GeographicPoint(x: statioinInfo.x, y: statioinInfo.y))
        
        if naviType == .naver {
            let urlStr = "nmap://route/car?dlat=\(convertedWGSPoint?.y ?? 0)&dlng=\(convertedWGSPoint?.x ?? 0)&dname=\(statioinInfo.brandName)"
            guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            guard let url = URL(string: encodedStr) else { return }
            let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.open(appStoreURL)
            }
        } else if naviType == .tmap {
            let routeInfo = [
                "rGoName": statioinInfo.brandName,
                "rGoX" : convertedWGSPoint?.x ?? 0,
                "rGoY" : convertedWGSPoint?.y ?? 0,
                "rV1Name" : statioinInfo.brandName] as [String : Any]
            
            _ = TMapApi.invokeRoute(routeInfo)
        } else if naviType == .kakao {
            let destination = NaviLocation(name: "\(statioinInfo.brandName)", x: "\(Int64(statioinInfo.x))", y: "\(Int64(statioinInfo.y))")
            guard let shareUrl = NaviApi.shared.shareUrl(destination: destination) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(shareUrl) {
                UIApplication.shared.open(shareUrl, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.open(NaviApi.webNaviInstallUrl, options: [:], completionHandler: nil)
            }
        } else if naviType == .apple {
            
        }
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
