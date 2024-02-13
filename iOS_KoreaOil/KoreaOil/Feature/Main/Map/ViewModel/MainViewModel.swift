//
//  MainViewModel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import CoreLocation
import AppTrackingTransparency
import AdSupport

class MainViewModel: NSObject, ViewModelType {
    private let defaults = UserDefaults.standard
    private var coordinator: MainCoordinator
    private var locationManager: CLLocationManager!
    private let geoConverter = GeoConverter()
    
    private var bag = DisposeBag()
    private let useCase = MainSceneUseCase()
    
    private let currentLatLonSubject = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private let aroundStationInfoSubject = PublishSubject<[AroundGasStation]>()
    private let minPriceStationGPSSubject = PublishSubject<GeographicPoint>()
    
    private var minPriceStationInfo: AroundGasStation?
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func transform(input: Input) -> Output {
        
        input.goMinBtnTap
            .withUnretained(self)
            .subscribeNext { owner, _ in
                if let minPriceStationInfo = owner.minPriceStationInfo {
                    let convertedWGSGPS = owner.geoConverter.convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: GeographicPoint(x: minPriceStationInfo.lon, y: minPriceStationInfo.lat))!
                    
                    owner.minPriceStationGPSSubject.onNext(convertedWGSGPS)
                }
            }
            .disposed(by: bag)
        
        let currentLatLonPost = self.currentLatLonSubject.asDriverOnErrorJustComplete()
        let aroundStationInfoPost = self.aroundStationInfoSubject.asDriverOnErrorJustComplete()
        let minPriceStationGPSPost = self.minPriceStationGPSSubject.asDriverOnErrorJustComplete()
        
        return Output(
            currentCoordinatePost: currentLatLonPost,
            aroundGasStationInfoPost: aroundStationInfoPost,
            minPriceStationGPSPost: minPriceStationGPSPost
        )
    }
    
    func getStationInfo() {
        let convertedKatecGPS = geoConverter.convert(sourceType: .WGS_84, destinationType: .KATEC, geoPoint: GeographicPoint(x: currentLatLonSubject.value.longitude, y: currentLatLonSubject.value.latitude))!
        
        let prodcd = OilType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDOilType) })?.resType ?? "B027"
        let radius = RangeType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDRangeType) })?.reqType ?? 0
        
        var param = Parameters()
        param["code"] = ApiKey().free
        param["out"] = "json"
        param["x"] = "\(String(convertedKatecGPS.x))"
        param["y"] = "\(String(convertedKatecGPS.y))"
        param["radius"] = radius
        param["prodcd"] = prodcd
        param["sort"] = "2"
        
        useCase.getAroundGasStation(param)
            .subscribeNext { [weak self] data in
                let stationInfos = data.value.result.oil
                self?.aroundStationInfoSubject.onNext(stationInfos)
                
                self?.minPriceStationInfo = self?.findCheapestStation(stationInfos: stationInfos)
            }
            .disposed(by: bag)
    }
    
    func stationMarkerTap(stationInfo: AroundGasStation) {
        self.coordinator.goStationDetail(stationInfo: stationInfo)
    }
    
    func findCheapestStation(stationInfos: [AroundGasStation]) -> AroundGasStation? {
        let sortedStations = stationInfos.sorted {
            if $0.price == $1.price {
                return $0.distance < $1.distance
            }
            return $0.price < $1.price
        }
        return sortedStations.first
    }
    
    func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("추적 권한 허가됨")
                print(ASIdentifierManager.shared().advertisingIdentifier)
            case .denied, .restricted, .notDetermined:
                print("추적 권한 거부됨 또는 미결정")
            @unknown default:
                print("알 수 없는 추적 권한 상태")
            }
        }
    }
}

extension MainViewModel {
    struct Input {
        let goMinBtnTap: Observable<Void>
    }
    
    struct Output {
        let currentCoordinatePost: Driver<CLLocationCoordinate2D>
        let aroundGasStationInfoPost: Driver<[AroundGasStation]>
        let minPriceStationGPSPost: Driver<GeographicPoint>
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLatLonSubject.accept(location.coordinate)
            locationManager.stopUpdatingLocation()
//            self.getStationInfo()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("위치 권한 허가됨")
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}
