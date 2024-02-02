//
//  RegionViewModel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class RegionViewModel: NSObject, ViewModelType {
    private var coordinator: RegionCoordinator
    private var locationManager: CLLocationManager!
    private var lastGeoCodingUpdateTime: Date?
    
    private let currentLocationSubject = BehaviorSubject<String>(value: "위치 정보 없음")
    
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
        
        return Output(
            titleTextPost: titleTextPost
        )
    }
}

extension RegionViewModel {
    struct Input {
        
    }
    
    struct Output {
        let titleTextPost: Driver<String>
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
