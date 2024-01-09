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
import iNaviMaps

class MainViewModel: NSObject, ViewModelType {
    var coordinator: Coordinator
    var locationManager: CLLocationManager!
    
    var bag = DisposeBag()
    let useCase = MainSceneUseCase()
    
    private let currentLatLonSubject = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        self.currentLatLonSubject
            .filter { $0.latitude != 0.0 }
            .take(1)
            .subscribeNext { [weak self] _ in
                self?.getStationInfo()
            }
            .disposed(by: bag)
    }
    
    func transform(input: Input) -> Output {
        
        let currentLatLonPost = self.currentLatLonSubject.asDriverOnErrorJustComplete()
        
        return Output(
            currentCoordinatePost: currentLatLonPost
        )
    }
    
    func getStationInfo() {
        let katecPoint = self.wgsToKatec(point: currentLatLonSubject.value)
        
        var param = Parameters()
        param["code"] = ApiKey().free
        param["out"] = "json"
        param["x"] = "\(String(katecPoint.x))"
        param["y"] = "\(String(katecPoint.y))"
        param["radius"] = "5000"
        param["prodcd"] = "B027"
        param["sort"] = "1"
        
        useCase.getAroundGasStation(param)
            .subscribeNext { data in
                print("DSFHISDFHI", data.value.result.oil)
            }
            .disposed(by: bag)
    }
    
    private func wgsToKatec(point: CLLocationCoordinate2D) -> INVKatec {
        let wgs84 = INVLatLng(lat: point.latitude, lng: point.longitude)
        let katec = INVKatec(latLng: wgs84)
        return katec
    }
}

extension MainViewModel {
    struct Input {
        
    }
    
    struct Output {
        let currentCoordinatePost: Driver<CLLocationCoordinate2D>
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
