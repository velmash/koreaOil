////
////  RegionResponse.swift
////  KoreaOil
////
////  Created by 윤형찬 on 1/16/24.
////
//
//import Foundation
//
//enum RegionCode: CaseIterable {
//    case seoul(SeoulCode)
//    case gyeongi
//    case gangwon
//    case chungbuk
//    case chungnam
//    case jeonbuk
//    case jeonnam
//    case gyeongbuk
//    case gyeongnam
//    case busan
//    case jeju
//    case daegu
//    case incheon
//    case gwangju
//    case daejeon
//    case ulsan
//    case sejong
//    
//    var name: String {
//        switch self {
//        case .seoul: "서울"
//        case .gyeongi: "경기"
//        case .gangwon: "강원"
//        case .chungbuk: "충북"
//        case .chungnam: "충남"
//        case .jeonbuk: "전북"
//        case .jeonnam: "전남"
//        case .gyeongbuk: "경북"
//        case .gyeongnam: "경남"
//        case .busan: "부산"
//        case .jeju: "제주"
//        case .daegu: "대구"
//        case .incheon: "인천"
//        case .gwangju: "광주"
//        case .daejeon: "대전"
//        case .ulsan: "울산"
//        case .sejong: "세종"
//        }
//    }
//    
//    var sidoCode: String {
//        switch self {
//        case .seoul: "01"
//        case .gyeongi: "02"
//        case .gangwon: "03"
//        case .chungbuk: "04"
//        case .chungnam: "05"
//        case .jeonbuk: "06"
//        case .jeonnam: "07"
//        case .gyeongbuk: "08"
//        case .gyeongnam: "09"
//        case .busan: "10"
//        case .jeju: "11"
//        case .daegu: "12"
//        case .incheon: "13"
//        case .gwangju: "14"
//        case .daejeon: "15"
//        case .ulsan: "16"
//        case .sejong: "17"
//        }
//    }
//}
//
//enum SeoulCode: String, CaseIterable {
//    case jongro = "종로구"
//    case joongu = "중구"
//    
//    var code: String {
//        switch self {
//        case .jongro: return "0101"
//        case .joongu: return "0102"
//        }
//    }
//}
