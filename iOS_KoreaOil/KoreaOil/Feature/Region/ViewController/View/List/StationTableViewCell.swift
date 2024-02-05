//
//  StationTableViewCell.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/1/24.
//

import UIKit
import CoreLocation

class StationTableViewCell: UITableViewCell {
    private let defaults = UserDefaults.standard
    
    private lazy var frameView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.backgroundColor = .white
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.text = "주유소 명"
    }
    
    private lazy var brandImg = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var distanceLb = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.text = "거리 : "
    }
    
    private lazy var seperator = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private lazy var priceLb = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.text = "가격 : "
    }
    
    private lazy var arrowImg = UIImageView().then {
        $0.image = UIImage(systemName: "greaterthan")
        $0.tintColor = .gray
        $0.contentMode = .scaleAspectFit
    }
    
    func configure(info: StationDetailInfo) {
        setupViews()
        setupConstraints()
        
        let prodcd = OilType.allCases.first(where: { $0.rawValue == defaults.string(forKey: UDOilType) })?.resType ?? "B027"
        guard let item = info.oilInfo.first(where: { $0.prodcd == prodcd}) else { return }
        
        print(info.brand)
        
        nameLabel.text = info.brandName
        brandImg.image = StationType.allCases.first(where: { $0.rawValue == info.brand })?.image
        
        var priceString = String(format: "%.0f", item.price)
        if let number = Int(priceString), number >= 1000 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // 천 단위 구분자 사용
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            
            if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
                priceString = formattedNumber
            }
        }
        
        distanceLb.text = "거리 : \(calcLocation(info: info))"
        priceLb.text = "가격 : ₩\(priceString)"
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        
        contentView.addSubview(frameView)
        frameView.addSubview(nameLabel)
        frameView.addSubview(brandImg)
        frameView.addSubview(distanceLb)
        frameView.addSubview(seperator)
        frameView.addSubview(priceLb)
        frameView.addSubview(arrowImg)
    }
    
    private func setupConstraints() {
        frameView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
        }
        
        brandImg.snp.makeConstraints {
            $0.top.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(4)
            $0.size.equalTo(20)
        }
        
        distanceLb.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        seperator.snp.makeConstraints {
            $0.leading.equalTo(distanceLb.snp.trailing).offset(7)
            $0.centerY.equalTo(distanceLb)
            $0.height.equalTo(10)
            $0.width.equalTo(1)
        }
        
        priceLb.snp.makeConstraints {
            $0.leading.equalTo(seperator.snp.trailing).offset(7)
            $0.bottom.equalTo(distanceLb.snp.bottom)
        }
        
        arrowImg.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func calcLocation(info: StationDetailInfo) -> String {
        let geoConverter = GeoConverter()
        let convertedLocation = geoConverter.convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: GeographicPoint(x: info.x, y: info.y))
        
        if let currentLocation = CLLocationManager().location, let destLoc = convertedLocation {
            let distance = currentLocation.distance(from: CLLocation(latitude: destLoc.y, longitude: destLoc.x))
            let formattedDistance = formatDistance(distance)
            
            return formattedDistance
        }
        return ""
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance >= 1000 {
            // km 단위 사용, 소수점 첫 번째 자리에서 반올림
            let distanceInKm = distance / 1000.0
            let roundedDistanceInKm = round(distanceInKm * 10) / 10
            return "\(roundedDistanceInKm)km"
        } else {
            // m 단위 사용, 반올림
            let roundedDistanceInMeters = round(distance)
            return "\(Int(roundedDistanceInMeters))m"
        }
    }
    
}
