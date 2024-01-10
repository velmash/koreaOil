//
//  MyLocationView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/9/24.
//

import UIKit
import SnapKit
import Then

class MyLocationView: BaseView {
    var stationInfo: AroundGasStation
    var isMinPriceStation: Bool
    
    lazy var centerPoint = UIView().then {
        $0.backgroundColor = .red
        $0.layer.masksToBounds = true
    }
    lazy var baloonView = UIImageView().then {
        $0.image = UIImage(named: "Baloon")
        $0.tintColor = .blue
    }
    
    lazy var brandImg = UIImageView().then {
        $0.image = stationInfo.stationType?.image
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var priceLb = UILabel().then {
        $0.text = "₩\(String(format: "%.0f", stationInfo.price))"
        $0.font = .systemFont(ofSize: 12)
        
        if isMinPriceStation {
            $0.font = .systemFont(ofSize: 13)
            $0.textColor = .red
        }
    }
    
    init(stationInfo: AroundGasStation, 
         isMinPriceStation: Bool,
         frame: CGRect = CGRect(origin: CGPoint(x: 30, y: 0), size: CGSize(width: 142, height: 50))) {
        self.stationInfo = stationInfo
        self.isMinPriceStation = isMinPriceStation
        
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerPoint.layer.cornerRadius = centerPoint.frame.size.width / 2
    }
    
    override func addSubviews() {
        addSubview(centerPoint)
        addSubview(baloonView)
        baloonView.addSubview(brandImg)
        baloonView.addSubview(priceLb)
    }
    
    override func addConstraints() {
        centerPoint.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(10)
        }
        
        baloonView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.bottom.equalTo(centerPoint.snp.top)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        
        brandImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6.2)
            $0.leading.equalToSuperview().offset(9.43)
            $0.size.equalTo(25)
        }
        
        priceLb.snp.makeConstraints {
            $0.centerY.equalTo(brandImg)
            $0.trailing.equalToSuperview().offset(-15)
        }
    }
}
