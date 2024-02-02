//
//  StationTableView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/1/24.
//

import UIKit

class StationTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.register(StationTableViewCell.self, forCellReuseIdentifier: "StationTableViewCell")
        self.separatorColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
