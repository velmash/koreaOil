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
    var coordinator: Coordinator
    var locationManager: CLLocationManager!
    
    var bag = DisposeBag()
    let useCase = MainSceneUseCase()
    
    private let currentLatLonSubject = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
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
        
        return Output(
            currentCoordinatePost: currentLatLonPost
        )
    }
    
    func getParam() {
        var param = Parameters()
        param["code"] = ApiKey().free
        param["out"] = "json"
        
        useCase.getAvgAllPrice(param)
            .compactMap { $0.value.result.oil }
            .subscribe(onNext: { avgList in
                print("ㅇㅇㅇ", avgList )
            })
            .disposed(by: bag)
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
            self.currentLatLonSubject.onNext(location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
}
