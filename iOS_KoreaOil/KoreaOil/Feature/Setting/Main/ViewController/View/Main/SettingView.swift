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
    var tableView = SettingTableView().then {
        $0.backgroundColor = .white
    }
    lazy var bannerView = GADBannerView(adSize: GADAdSizeBanner).then {
        $0.adUnitID = "ca-app-pub-4670694619553812/1289163765" //Test ID
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
    
    lazy var payBtn = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.title = "개발자에게 커피 사주기"
        config.baseForegroundColor = .gray // 타이틀 색상
        config.baseBackgroundColor = .white // 배경 색상
        
        let tintColor = UIColor.gray // 이미지 색상 설정
        if let originalImage = UIImage(systemName: "hand.point.left.fill"),
           let resizedImage = originalImage.resized(toWidth: 18)?.withTintColor(tintColor) {
            config.image = resizedImage
        }
        
        config.imagePlacement = .trailing // 이미지를 오른쪽에 배치
        config.imagePadding = 5 // 텍스트와 이미지 사이의 패딩
        config.cornerStyle = .medium // 버튼 모서리 스타일
        
        // 폰트 설정
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 16)
            return outgoing
        }
        
        $0.configuration = config
    }
    
    lazy var loadingIndicator = UIActivityIndicatorView().then {
        $0.frame = CGRect(x: 10, y: 5, width: 50, height: 50)
        $0.hidesWhenStopped = true
        $0.style = .large
    }
    
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
        self.addSubview(payBtn)
        self.addSubview(loadingIndicator)
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
        
        self.payBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.tableView.snp.top).offset(260)
        }
        
        self.loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

