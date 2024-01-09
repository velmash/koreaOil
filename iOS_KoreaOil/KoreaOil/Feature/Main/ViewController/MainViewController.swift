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
    private var bag = DisposeBag()
    
    var viewModel: MainViewModel?
    
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
                let mapView = self?.contentView.mapView
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude))
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                marker.iconImage = NMFOverlayImage(image: self!.convertViewToImage(view: MyLocationView()))
                
                mapView?.moveCamera(cameraUpdate)
                marker.mapView = mapView
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
