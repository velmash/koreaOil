//
//  SettingTableViewCell.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import UIKit

class BottomSheetTableViewCell: UITableViewCell {
    let defaults = UserDefaults.standard
    
    // 여기에 셀 구성을 위한 뷰들을 추가합니다.
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private lazy var appIcon = UIImageView().then {
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var checkedImg = UIImageView().then {
        $0.image = UIImage(resource: .checkImg)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray
    }
    
    func configure(title: String) {
        self.backgroundColor = .white
        
        titleLabel.text = title
        
        let userDefaultsKeys = [UDOilType, UDRangeType, UDNaviType]
        let userDefaultsValues = userDefaultsKeys.compactMap { defaults.string(forKey: $0) }
        checkedImg.isHidden = !userDefaultsValues.contains(title)
        
        if title == "네이버지도" {
            appIcon.image = UIImage(resource: .naverMap)
        } else if title == "카카오내비" {
            appIcon.image = UIImage(resource: .kakaoNavi)
        } else if title == "티맵" {
            appIcon.image = UIImage(resource: .tmap)
        } else if title == "애플지도" {
            appIcon.image = UIImage(resource: .logoApple)
        } else if title == "0.1" || title == "0.5" {
            let num = Int(Double(title)! * 1000)
            titleLabel.text! = "\(num) m"
            appIcon.image = nil
        } else if title == "1" || title == "3" || title == "5" {
            titleLabel.text! = "\(title) km"
            appIcon.image = nil
        } else {
            appIcon.image = nil
        }
        
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        self.selectionStyle = .none
        
        // 서브뷰 추가
        contentView.addSubview(titleLabel)
        contentView.addSubview(appIcon)
        contentView.addSubview(checkedImg)
    }

    private func setupConstraints() {
        // SnapKit을 사용하여 제약 조건 설정
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        appIcon.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(25)
        }
        
        checkedImg.snp.makeConstraints {
            $0.size.equalTo(15)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
