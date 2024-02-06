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
    
    private let currentLocationSubject = BehaviorSubject<String>(value: "위치 정보 없음")
    private let stationInfoSubject = PublishSubject<[StationDetailInfo]>()
    
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
        param["code"] = ApiKey().free
        param["out"] = "json"
        param["area"] = "0202"
        
        let oilPricesObservable = useCase.getOilPricesOfRegion(param)
            .compactMap { $0.value.result.oil }
        
        let filteredOilPricesObservable = oilPricesObservable
            .flatMap { Observable.from($0) }
            .filter { $0.prodcd == prodcd }
            .toArray()
            .map { $0.sorted(by: { $0.price < $1.price }) }
            .asObservable()
            .flatMap { prices -> Observable<[StationDetailInfo]> in
                let limitedPrices = Array(prices.prefix(10)) //TODO: 서버 DB Call로 추후 변경 필요
                let detailObservables = limitedPrices.map { self.getStationDetailInfo(stationId: $0.stationId) }
                return Observable.combineLatest(detailObservables)
            }
        
        filteredOilPricesObservable
            .withUnretained(self)
            .subscribeNext { owner, details in
                owner.stationInfoSubject.onNext(details)
//                print("Details: \(details)")
            }
            .disposed(by: bag)
    }
    
    func cellTap(info: StationDetailInfo) {
        let prodcd = OilType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDOilType) })?.resType ?? "B027"
        guard let item = info.oilInfo.first(where: { $0.prodcd == prodcd}) else { return }
        
        let aa = AroundGasStation(stationId: info.stationId, brand: info.brand, brandName: info.brandName, price: item.price, distance: 0.0, lon: info.x, lat: info.y)
        self.coordinator.goStationDetail(stationInfo: aa)
    }
    
    private func getStationDetailInfo(stationId: String) -> Observable<StationDetailInfo> {
        var param = Parameters()
        param["code"] = ApiKey().free
        param["out"] = "json"
        param["id"] = stationId
        
        return mainUseCase.getStationDetailInfo(param)
            .compactMap { $0.value.result.oil.first }
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
//                    print("시(도): \(address.administrativeArea ?? "N/A")")
//                    print("구(군): \(address.locality ?? "N/A")")
                    if let siStr = address.administrativeArea, let guStr = address.locality {
                        self.currentLocationSubject.onNext("\(siStr) \(guStr)")
                    }
                }
            }
        }
    }
}
