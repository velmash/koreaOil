//
//  TabBarItemType.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation

enum TabBarItemType: String, CaseIterable {
    case home, chart, region, setting
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .chart
        case 2: self = .region
        case 3: self = .setting
        default: return nil
        }
    }
    
    func toInt() -> Int {
        switch self {
        case .home: return 0
        case .chart: return 1
        case .region: return 2
        case .setting: return 3
        }
    }
    
    func toKrName() -> String {
        switch self {
        case .home: return "내 주변"
        case .chart: return "유가동향"
        case .region: return "지역별"
        case .setting: return "설정"
        }
    }
    
    func toIconName() -> String {
        switch self {
        case .home: return "person.2"
        case .chart: return "chart.xyaxis.line"
        case .region: return "map"
        case .setting: return "gearshape"
        }
    }
}
