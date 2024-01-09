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
    lazy var centerPoint = UIView().then {
        $0.backgroundColor = .red
        $0.layer.masksToBounds = true
    }
    lazy var baloonView = UIImageView().then {
        $0.image = UIImage(named: "Baloon")
        $0.tintColor = .blue
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: CGPoint(x: 30, y: 0), size: CGSize(width: 162, height: 70)))
        
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
    }
    
    override func addConstraints() {
        centerPoint.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(10)
        }
        
        baloonView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(23)
            $0.bottom.equalTo(centerPoint.snp.top)
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
    }
}
