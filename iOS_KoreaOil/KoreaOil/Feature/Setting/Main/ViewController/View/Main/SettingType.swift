//
//  SettingType.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/13/23.
//

import Foundation

enum SettingType: CaseIterable {
    case oilType
    case regionRange
    case naviType
    case source
    
    var title: String {
        switch self {
        case .oilType: return "유종"
        case .regionRange: return "반경 범위"
        case .naviType: return "길안내 앱"
        case .source: return "출처"
        }
    }
    
    func getAllCases() -> [String] {
        switch self {
        case .oilType:
            return OilType.allCases.map { $0.rawValue }
        case .regionRange:
            return RangeType.allCases.map { $0.rawValue }
        case .naviType:
            return NaviType.allCases.map { $0.rawValue }
        default: return []
        }
    }
    
    func getUDType() -> String {
        switch self {
        case .oilType:
            return UDOilType
        case .regionRange:
            return UDRangeType
        case .naviType:
            return UDNaviType
        default: return ""
        }
    }
}
