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

class MainViewModel: NSObject, ViewModelType {
    let defaults = UserDefaults.standard
    var coordinator: Coordinator
    var locationManager: CLLocationManager!
    
    var bag = DisposeBag()
    let useCase = MainSceneUseCase()
    
    private let currentLatLonSubject = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private let aroundStationInfoSubject = PublishSubject<[AroundGasStation]>()
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func transform(input: Input) -> Output {
        
        let currentLatLonPost = self.currentLatLonSubject.asDriverOnErrorJustComplete()
        let aroundStationInfoPost = self.aroundStationInfoSubject.asDriverOnErrorJustComplete()
        
        return Output(
            currentCoordinatePost: currentLatLonPost,
            aroundGasStationInfoPost: aroundStationInfoPost
        )
    }
    
    func getStationInfo() {
        let converter = GeoConverter()
        let dd = converter.convert(sourceType: .WGS_84, destinationType: .KATEC, geoPoint: GeographicPoint(x: currentLatLonSubject.value.longitude, y: currentLatLonSubject.value.latitude))!
        
        let prodcd = OilType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDOilType) })?.resType ?? "B027"
        let radius = RangeType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDRangeType) })?.reqType ?? 0
        
        var param = Parameters()
        param["code"] = ApiKey().free
        param["out"] = "json"
        param["x"] = "\(String(dd.x))"
        param["y"] = "\(String(dd.y))"
        param["radius"] = radius
        param["prodcd"] = prodcd
        param["sort"] = "1"
        
        useCase.getAroundGasStation(param)
            .subscribeNext { [weak self] data in
                self?.aroundStationInfoSubject.onNext(data.value.result.oil)
            }
            .disposed(by: bag)
    }
}

extension MainViewModel {
    struct Input {
        
    }
    
    struct Output {
        let currentCoordinatePost: Driver<CLLocationCoordinate2D>
        let aroundGasStationInfoPost: Driver<[AroundGasStation]>
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLatLonSubject.accept(location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
}
