//
//  MainViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NMapsMap
import AppTrackingTransparency

class MainViewController: BaseViewController<MainView> {
    private var currentMarker = NMFMarker()
    private var stationMarkers = [NMFMarker]()
    
    var viewModel: MainViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.contentView.goMinPriceBtn.isHidden = false
        self.viewModel?.getStationInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.mapView?.touchDelegate = self
        contentView.mapView?.addCameraDelegate(delegate: self)
        contentView.searchBar.delegate = self
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = MainViewModel.Input(
            goMinBtnTap: self.contentView.goMinPriceBtn.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.currentCoordinatePost
            .doOnNext { [weak self] _ in
                guard let self = self else { return }
                
                currentMarker.mapView = nil
                currentMarker = NMFMarker()
            }
            .driveNext { [weak self] coordinate in
                guard let self = self else { return }
                
                let mapView = self.contentView.mapView
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude))
                currentMarker.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                currentMarker.captionText = "내 위치"
                currentMarker.captionAligns = [NMFAlignType.top]
                mapView?.moveCamera(cameraUpdate)
                currentMarker.mapView = mapView
            }
            .disposed(by: bag)
        
        output.aroundGasStationInfoPost
            .doOnNext { [weak self] _ in
                self?.viewModel?.requestTrackingAuthorization()
            }
            .doOnNext { [weak self] _ in
                guard let self = self else { return }
                
                for marker in self.stationMarkers {
                    marker.mapView = nil
                }
                
                self.stationMarkers = []
            }
            .doOnNext { [weak self] stations in
                if stations.count <= 0 {
                    self?.contentView.goMinPriceBtn.isHidden = true
                    iToast.show("주변에 주유소가 없습니다. \"설정\"으로 이동하여, 반경 범위 조건을 변경 해 주세요.")
                }
                return
            }
            .driveNext { [weak self] stations in
                guard let self = self else { return }
                
                let mapView = self.contentView.mapView
                
                let minPriceStation = viewModel.findCheapestStation(stationInfos: stations)
                
                for stationInfo in stations {
                    let marker = NMFMarker()
                    
                    let isMinPriceStation = stationInfo == minPriceStation
                    let latlon = GeoConverter().convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: GeographicPoint(x: stationInfo.lon, y: stationInfo.lat))!
                    let locationView = MyLocationView(stationInfo: stationInfo, isMinPriceStation: isMinPriceStation)
                    
                    marker.position = NMGLatLng(lat: latlon.y, lng: latlon.x)
                    marker.iconImage = NMFOverlayImage(image: self.convertViewToImage(view: locationView))
                    
                    marker.touchHandler = { overlay in
                        self.viewModel?.stationMarkerTap(stationInfo: locationView.stationInfo)
                        return true
                    }
                    
                    marker.mapView = mapView
                    
                    self.stationMarkers.append(marker)
                }
            }
            .disposed(by: bag)
        
        output.minPriceStationGPSPost
            .driveNext { [weak self] wgsGps in
                guard let self = self else { return }
                
                self.contentView.goMinPriceBtn.isHidden = true
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: wgsGps.y, lng: wgsGps.x), zoomTo: 16)
                cameraUpdate.animation = .fly
                cameraUpdate.animationDuration = 1
                self.contentView.mapView?.moveCamera(cameraUpdate) { _ in
                    self.contentView.goMinPriceBtn.isHidden = true
                }
            }
            .disposed(by: bag)
        
        contentView.searchView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .subscribeNext { owner, _ in
                owner.contentView.searchBar.resignFirstResponder()
            }
            .disposed(by: bag)
    }
}

extension MainViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng.lat), \(latlng.lng)")
    }
}

extension MainViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        self.contentView.goMinPriceBtn.isHidden = false
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.contentView.showBottomView()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // 검색 입력이 끝났을 때의 처리 로직
        self.contentView.hideBottomView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 취소 버튼이 탭되었을 때의 처리 로직
        self.contentView.hideBottomView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 버튼이 탭되었을 때의 처리 로직
        self.contentView.hideBottomView()
    }
}
