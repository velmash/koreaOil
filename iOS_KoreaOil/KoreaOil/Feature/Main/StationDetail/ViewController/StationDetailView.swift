//
//  StationDetailView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/10/24.
//

import UIKit
import NMapsMap
import SnapKit
import Then

class StationDetailView: BaseView {
    var mapView: NMFMapView?
    
    lazy var topBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var titleLb = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.text = "주유소 상세 정보"
    }
    
    lazy var detailContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
    }
    
    lazy var stationTitleLb = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .black
    }
    
    lazy var btnContainerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var stopoverBtn = makeRouteBtn(isDest: false)
    lazy var destBtn = makeRouteBtn(isDest: true)
    
    lazy var descScrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    lazy var callBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
    }
    
    lazy var isCarWashLb = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .black
    }
    
    lazy var isStoreLb = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        mapView = NMFMapView(frame: self.frame)
        
        self.addSubview(topBar)
        self.topBar.addSubview(backBtn)
        self.topBar.addSubview(titleLb)
        
        self.addSubview(detailContainerView)
        detailContainerView.addSubview(stationTitleLb)
        detailContainerView.addSubview(btnContainerView)
        detailContainerView.addSubview(descScrollView)
        
        if let mapView {
            mapView.zoomLevel = 17
            mapView.isScrollGestureEnabled = false
            mapView.isTiltGestureEnabled = false
            mapView.isRotateGestureEnabled = false
            mapView.isZoomGestureEnabled = false
            
            descScrollView.addSubview(mapView)
        }
        
        descScrollView.addSubview(callBtn)
        descScrollView.addSubview(isCarWashLb)
        descScrollView.addSubview(isStoreLb)
        
        btnContainerView.addSubview(stopoverBtn)
        btnContainerView.addSubview(destBtn)
    }
    
    override func addConstraints() {
        self.topBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topSafetyAreaInset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        self.backBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(topBar.snp.height)
        }
        
        titleLb.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        detailContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-(20 + bottomSafetyAreaInset + tabBarHeight))
            $0.top.equalTo(topBar.snp.bottom).offset(30)
        }
        
        stationTitleLb.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        btnContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        stopoverBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(btnContainerView.snp.centerX).offset(-10)
        }
        
        destBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(btnContainerView.snp.centerX).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        descScrollView.snp.makeConstraints {
            $0.top.equalTo(stationTitleLb.snp.bottom).offset(15)
            $0.bottom.equalTo(btnContainerView.snp.top).offset(-15)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        if let mapView {
            mapView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.size.equalTo(descScrollView.snp.width)
            }
            
            callBtn.snp.makeConstraints {
                $0.top.equalTo(mapView.snp.bottom).offset(10)
                $0.leading.equalToSuperview()
                $0.size.equalTo(30)
            }
            isCarWashLb.snp.makeConstraints {
                $0.top.equalTo(callBtn.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview()
            }
            isStoreLb.snp.makeConstraints {
                $0.top.equalTo(isCarWashLb.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview()
                
                $0.bottom.equalToSuperview().offset(-10)
            }
        }
    }
    
    func bindStationInfoUI(info: AroundGasStation) {
        setTitleAttrStr(info)
        self.setMapview(info)
    }
    
    func bindStationInfoDetailUI(info: StationDetailInfo) {
        self.isCarWashLb.text = "· 세차장 유무: \(info.isCarWash ? "O" : "X")"
        self.isStoreLb.text = "· 편의점 유뮤: \(info.isStore ? "O" : "X")"
    }
    
    private func setTitleAttrStr(_ info: AroundGasStation) {
        let textAttachment = NSTextAttachment()
        textAttachment.image = info.stationType?.image
        
        let imageSize = textAttachment.image!.size
        let scaleFactor = imageSize.height / stationTitleLb.font.lineHeight
        textAttachment.bounds = CGRect(x: 0, y: -4, width: imageSize.width / scaleFactor, height: imageSize.height / scaleFactor)

        let fullString = NSMutableAttributedString(string: "\(info.brandName) ")
        fullString.append(NSAttributedString(attachment: textAttachment))

        stationTitleLb.attributedText = fullString
    }
    
    private func setMapview(_ info: AroundGasStation) {
        self.mapView?.clipsToBounds = true
        self.mapView?.layer.cornerRadius = 15
        
        if let wgsGps = GeoConverter().convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: GeographicPoint(x: info.lon, y: info.lat)) {
            
            let currentPoint = NMGLatLng(lat: wgsGps.y, lng: wgsGps.x)
            let cameraUpdate = NMFCameraUpdate(scrollTo: currentPoint, zoomTo: 17)
            let marker = NMFMarker()
            marker.position = currentPoint
            
            mapView?.moveCamera(cameraUpdate)
            marker.mapView = mapView
        }
    }
    
    private func makeRouteBtn(isDest: Bool) -> UIButton {
        let btn = UIButton()
        
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 15
        
        btn.layer.borderColor = isDest ? UIColor.gray.cgColor : UIColor.white.cgColor
        btn.backgroundColor = isDest ? .white : .gray
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitle(isDest ? "길 안내" : "경유지로", for: .normal)
        btn.setTitleColor(isDest ? .black : .white, for: .normal)
        
        return btn
    }
}
