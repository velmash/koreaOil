//
//  RegionView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit

class RegionView: BaseView {
    lazy var label = UILabel().then {
        $0.text = "기름 최저가 리스트 구현해라 윤형찬"
        $0.font = .systemFont(ofSize: 30)
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
        addSubview(label)
    }
    
    override func addConstraints() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
