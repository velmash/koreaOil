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

class MainViewController: BaseViewController<MainView> {
    var viewModel: MainViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.getStationInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.vc = self
        contentView.mapView?.touchDelegate = self
        contentView.searchBar.delegate = self
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = MainViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.currentCoordinatePost
            .driveNext { [weak self] coordinate in
                guard let self = self else { return }
                
                let mapView = self.contentView.mapView
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude))
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                marker.captionText = "내 위치"
                marker.captionAligns = [NMFAlignType.top]
                mapView?.moveCamera(cameraUpdate)
                marker.mapView = mapView
            }
            .disposed(by: bag)
        
        output.aroundGasStationInfoPost
            .driveNext { [weak self] stations in
                guard let self = self else { return }
                
                let mapView = self.contentView.mapView
                
                for stationInfo in stations {
                    let marker = NMFMarker()
                    let latlon = GeoConverter().convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: GeographicPoint(x: stationInfo.lon, y: stationInfo.lat))!
                    marker.position = NMGLatLng(lat: latlon.y, lng: latlon.x)
                    marker.iconImage = NMFOverlayImage(image: self.convertViewToImage(view: MyLocationView(stationInfo: stationInfo)))
                    marker.mapView = mapView
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
