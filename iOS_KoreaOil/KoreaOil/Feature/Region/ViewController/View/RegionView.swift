//
//  RegionView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import GoogleMobileAds

class RegionView: BaseView {
    var tableView = StationTableView().then {
        $0.backgroundColor = .white
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = " - "
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    lazy var noDataView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var noDataLb = UILabel().then {
        $0.text = "표시 데이터 없음"
        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .black
    }
    
    lazy var nodataImg = UIImageView().then {
        $0.image = UIImage(systemName: "x.square")
        $0.tintColor = .gray
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.noDataView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(noDataView)
        noDataView.addSubview(noDataLb)
        noDataView.addSubview(nodataImg)
    }
    
    override func addConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20 + self.topSafetyAreaInset)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-(self.bottomSafetyAreaInset + self.tabBarHeight))
        }
        
        noDataView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-(self.bottomSafetyAreaInset + self.tabBarHeight))
        }
        
        noDataLb.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noDataView.snp.centerY)
        }
        
        nodataImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(noDataLb.snp.top).offset(-10)
            $0.size.equalTo(40)
        }
    }
    
    func makeBannerView() -> GADBannerView {
        return GADBannerView(adSize: GADAdSizeBanner).then {
            $0.adUnitID = "ca-app-pub-4670694619553812/3440135644"
            $0.load(GADRequest())
        }
    }
}
