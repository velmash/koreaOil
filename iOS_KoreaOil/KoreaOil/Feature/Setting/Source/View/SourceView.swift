//
//  SourceView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/13/23.
//

import UIKit
import Then
import SnapKit

class SourceView: BaseView {
    lazy var topBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var opiIconImg = UIImageView().then {
        $0.image = UIImage(named: "OpinetIcon")
    }
    
    lazy var descLb = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "한국석유공사 · 오피넷"
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
        self.addSubview(topBar)
        self.topBar.addSubview(backBtn)
        self.addSubview(opiIconImg)
        self.addSubview(descLb)
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
        
        self.opiIconImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.equalTo(90)
            $0.height.equalTo(38)
        }
        
        self.descLb.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)
        }
        
        self.backBtn.bringSubviewToFront(topBar)
    }
}
