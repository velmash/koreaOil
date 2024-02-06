//
//  RegionView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import GoogleMobileAds

class RegionView: BaseView {
    var tableView = StationTableView()
    
    lazy var titleLabel = UILabel().then {
        $0.text = " - "
        $0.font = .systemFont(ofSize: 16)
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
        addSubview(titleLabel)
        addSubview(tableView)
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
    }
    
    func makeBannerView() -> GADBannerView {
        return GADBannerView(adSize: GADAdSizeBanner).then {
            $0.adUnitID = "ca-app-pub-4670694619553812/3440135644"
            $0.load(GADRequest())
        }
    }
}
