//
//  SettingListView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import UIKit

class BottomSheetTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        // 추가적인 테이블 뷰 설정
        self.register(BottomSheetTableViewCell.self, forCellReuseIdentifier: "BottomSheetTableViewCell")
        
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
