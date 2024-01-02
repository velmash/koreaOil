//
//  BottomSheetView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/14/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class BottomSheetView: BaseView {
    private var bag = DisposeBag()
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    lazy var closeBt = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var titleLb = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.text = "선택"
    }
    
    lazy var tableView = BottomSheetTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        self.closeBt.rx.tap
            .asDriverOnErrorJustComplete()
            .driveNext { [weak self] _ in
                self?.isHidden = true
            }
            .disposed(by: bag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(closeBt)
        contentView.addSubview(titleLb)
        contentView.addSubview(tableView)
    }
    
    override func addConstraints() {
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo((deviceHeight - tabBarHeight - bottomSafetyAreaInset)/2)
        }
        
        closeBt.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        titleLb.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(closeBt)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(closeBt.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
}
