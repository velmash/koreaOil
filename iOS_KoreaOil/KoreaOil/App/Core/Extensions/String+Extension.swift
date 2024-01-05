//
//  String+Extension.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation

extension String {
    func convertDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy년 MM월 d일"
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
    
    func convertChartsDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MM.d"
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
}

