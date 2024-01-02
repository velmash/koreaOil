//
//  SettingView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import Then
import SnapKit
import GoogleMobileAds

class SettingView: BaseView {
    weak var vc: SettingViewController?
    
    var tableView = SettingTableView()
    lazy var bannerView = GADBannerView(adSize: GADAdSizeBanner).then {
        $0.adUnitID = "ca-app-pub-3940256099942544/2934735716" //Test ID
        $0.load(GADRequest())
    }
    
    lazy var topBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var topBarTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 36)
        $0.textColor = .black
        $0.text = "설정"
    }
    
    lazy var bottomSheet = BottomSheetView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        self.addSubview(topBar)
        self.topBar.addSubview(topBarTitle)
        self.addSubview(tableView)
        self.addSubview(bannerView)
        self.addSubview(bottomSheet)
    }
    
    override func addConstraints() {
        self.topBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topSafetyAreaInset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.topBarTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview()
        }
        
        self.bannerView.snp.makeConstraints( {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(bottomSafetyAreaInset + tabBarHeight))
        })
        
        self.bottomSheet.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(bannerView.snp.bottom)
        }
    }
}

