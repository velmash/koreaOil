//
//  UserDefaultKeys.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/13/23.
//

import Foundation

let UDOilType = "OILTYPE"
let UDRangeType = "REGIONRANGE"
let UDNaviType = "UDNAVITYPE"

enum OilType: String, CaseIterable {
    case gasolin = "휘발유"
    case disel = "경유"
    case kerosene = "등유"
    case premium = "고급휘발유"
    case gas = "LPG"
    
    var resType: String {
        switch self {
        case .gasolin: "B027"
        case .disel: "D047"
        case .kerosene: "C004"
        case .premium: "B034"
        case .gas: "K015"
        }
    }
}

enum RangeType: String, CaseIterable {
    case oneK = "1"
    case threeK = "3"
    case fiveK = "5"
    case tenK = "10"
    case thirtyK = "30"
}

enum NaviType: String, CaseIterable {
    case naver = "네이버지도"
    case kakao = "카카오내비"
    case tmap = "티맵"
}
