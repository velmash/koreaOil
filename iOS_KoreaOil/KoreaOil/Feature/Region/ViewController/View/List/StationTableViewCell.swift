//
//  StationTableViewCell.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/1/24.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.text = "테스트요"
    }
    
    func configure() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
