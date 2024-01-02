//
//  SettingTableViewCell.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    let defaults = UserDefaults.standard
    
    // 여기에 셀 구성을 위한 뷰들을 추가합니다.
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private lazy var subLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    private lazy var arrowImg = UIImageView().then {
        $0.image = UIImage(systemName: "gearshape.2.fill")
        $0.tintColor = .gray
    }

    func configure(with item: SettingType) {
        titleLabel.text = item.title
        
        switch item {
        case .oilType:
            arrowImg.image = UIImage(systemName: "gearshape.2.fill")
            subLabel.text = defaults.string(forKey: UDOilType)
        case .regionRange:
            arrowImg.image = UIImage(systemName: "gearshape.2.fill")
            subLabel.text = "\(String(describing: defaults.string(forKey: UDRangeType)!))km"
        case .naviType:
            arrowImg.image = UIImage(systemName: "gearshape.2.fill")
            subLabel.text = defaults.string(forKey: UDNaviType)
        case .source:
            arrowImg.image = UIImage(systemName: "chevron.right")
            subLabel.text = ""
        }
        
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        self.selectionStyle = .none
        
        // 서브뷰 추가
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImg)
        contentView.addSubview(subLabel)
    }

    private func setupConstraints() {
        // SnapKit을 사용하여 제약 조건 설정
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        arrowImg.snp.makeConstraints {
            $0.size.equalTo(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.trailing.equalTo(arrowImg.snp.leading).offset(-5)
            $0.centerY.equalToSuperview()
        }
    }
}
