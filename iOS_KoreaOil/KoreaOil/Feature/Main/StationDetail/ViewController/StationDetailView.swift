//
//  StationDetailView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/10/24.
//

import UIKit
import SnapKit
import Then

class StationDetailView: BaseView {
    lazy var tempLb = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        addSubview(tempLb)
    }
    
    override func addConstraints() {
        tempLb.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
