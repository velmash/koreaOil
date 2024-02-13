//
//  RegionViewModel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import CoreLocation

class RegionViewModel: NSObject, ViewModelType {
    private let defaults = UserDefaults.standard
    private var coordinator: RegionCoordinator
    private var locationManager: CLLocationManager!
    private var lastGeoCodingUpdateTime: Date?
    
    private var bag = DisposeBag()
    private let useCase = RegionSceneUseCase()
    private let mainUseCase = MainSceneUseCase()
    
    private let currentLocationSubject = BehaviorRelay<String>(value: "위치 정보 없음")
    private let stationInfoSubject = PublishSubject<[StationDetailInfo]>()
    
    let tempSubject = BehaviorSubject<String>(value: "위치")
    
    init(coordinator: RegionCoordinator) {
        self.coordinator = coordinator
        super.init()
        
        self.lastGeoCodingUpdateTime = nil
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func transform(input: Input) -> Output {
        let titleTextPost = self.currentLocationSubject.asDriverOnErrorJustComplete()
        let stationInfoPost = self.stationInfoSubject.asDriverOnErrorJustComplete()
        
        return Output(
            titleTextPost: titleTextPost,
            stationInfoPost: stationInfoPost
        )
    }
    
    func getPrices() {
        let prodcd = OilType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDOilType) })?.resType ?? "B027"
        
        var param = Parameters()
        param["prodcd"] = prodcd
        param["regionName"] = currentLocationSubject.value
        
        useCase.requestRegionStationDetailInfo(param)
            .withUnretained(self)
            .subscribeNext { owner, res in
                var details = [StationDetailInfo]()
                
                for item in res.value.details {
                    if let detail = item.OIL.first {
                        details.append(detail)
                    }
                }
                
                owner.stationInfoSubject.onNext(details)
            }
            .disposed(by: bag)
    }
    
    func cellTap(info: StationDetailInfo) {
        let prodcd = OilType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDOilType) })?.resType ?? "B027"
        guard let item = info.oilInfo.first(where: { $0.prodcd == prodcd}) else { return }
        
        let aa = AroundGasStation(stationId: info.stationId, brand: info.brand, brandName: info.brandName, price: item.price, distance: 0.0, lon: info.x, lat: info.y)
        self.coordinator.goStationDetail(stationInfo: aa)
    }
}

extension RegionViewModel {
    struct Input {
        
    }
    
    struct Output {
        let titleTextPost: Driver<String>
        let stationInfoPost: Driver<[StationDetailInfo]>
    }
}

extension RegionViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let now = Date()
            if let lastUpdateTime = self.lastGeoCodingUpdateTime, now.timeIntervalSince(lastUpdateTime) < 60 {
                // 마지막 지오코딩 이후 1분이 지나지 않았다면 아무것도 하지 않음
                return
            }

            self.lastGeoCodingUpdateTime = now

            // 1분이 경과했으므로 지오코딩 수행
            let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let locale = Locale(identifier: "Ko-kr")
            let geoCoder = CLGeocoder()

            geoCoder.reverseGeocodeLocation(currentLocation, preferredLocale: locale) { (places, error) in
                if let address = places?.last {
                    if let siStr = address.administrativeArea, let guStr = address.locality {
                        self.currentLocationSubject.accept("\(siStr) \(guStr)")
                        
                        let locationStr = "\(address.name)\n\(address.thoroughfare)\n\(address.subThoroughfare)\n\(address.locality)\n\(address.subLocality)\n\(address.administrativeArea)\n\(address.subAdministrativeArea)\n\(address.postalCode)\n\(address.isoCountryCode)\n\(address.country)\n\(address.inlandWater)\n\(address.ocean)\n\(address.areasOfInterest)"
                        
                        self.tempSubject.onNext(locationStr)
                    }
                }
            }
        }
    }
}
