//
//  BaseView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import UIKit

class BaseView: UIView {
    let deviceHeight = UIScreen.main.bounds.height
    let topSafetyAreaInset = (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first!.safeAreaInsets.top
    let bottomSafetyAreaInset = (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first!.safeAreaInsets.bottom
    let tabBarHeight: CGFloat = 48
    
    // 이 생성자는 코드로 뷰를 초기화할 때 사용됩니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubviews()
        addConstraints()
    }

    func addSubviews() { }
    func addConstraints() { }
}
