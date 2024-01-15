//
//  MainResponse.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation

struct AroundGasStationResponse: Codable {
    var result: GasStaionResult

    enum CodingKeys: String, CodingKey {
        case result = "RESULT"
    }
}

struct GasStaionResult: Codable {
    var oil: [AroundGasStation]

    enum CodingKeys: String, CodingKey {
        case oil = "OIL"
    }
}

struct AroundGasStation: Codable, Hashable {
    var stationId: String
    var brand: String
    var brandName: String
    var price: Double
    var distance: Double
    var lon: Double
    var lat: Double
    
    enum CodingKeys: String, CodingKey {
        case stationId = "UNI_ID"
        case brand = "POLL_DIV_CD"
        case brandName = "OS_NM"
        case price = "PRICE"
        case distance = "DISTANCE"
        case lon = "GIS_X_COOR"
        case lat = "GIS_Y_COOR"
    }
    
    var stationType: StationType? {
        return StationType.allCases.first(where: { $0.rawValue == brand })
    }
}

enum StationType: String, CaseIterable {
    case skEnergy = "SKE"
    case gsCaltex = "GSC"
    case hdOilBank = "HDO"
    case sOil = "SOL"
    case thrifty = "RTE"
    case ex = "RTX"
    case nhThrifty = "NHO"
    case etc = "ETC"
    case e1 = "E1G"
    case skGas = "SKG"
    
    var image: UIImage? {
        switch self {
        case .skEnergy: UIImage(named: "logo_sk")
        case .gsCaltex: UIImage(named: "logo_gs")
        case .hdOilBank: UIImage(named: "logo_hd")
        case .sOil: UIImage(named: "logo_soil")
        case .thrifty: UIImage(named: "logo_rte")
        case .ex: UIImage(named: "logo_rtx")
        case .nhThrifty: UIImage(named: "logo_nh")
        case .etc: UIImage(named: "logo_station")
        case .e1: UIImage(named: "logo_e1")
        case .skGas: UIImage(named: "logo_sk")
        }
    }
}


struct StationDetailInfoResponse: Codable {
    var result: StationDetailInfoResult

    enum CodingKeys: String, CodingKey {
        case result = "RESULT"
    }
}

struct StationDetailInfoResult: Codable {
    var oil: [StationDetailInfo]

    enum CodingKeys: String, CodingKey {
        case oil = "OIL"
    }
}

struct StationDetailInfo: Codable, Hashable {
    var stationId: String
    var brand: String?
    var gBrand: String?
    var brandName: String
    var addrOld: String
    var addrNew: String
    var phoneNum: String
    var regionCode: String
    var type: String
    var _isMaint: String
    var _isCarWash: String
    var _isCertied: String
    var _isStore: String
    var x: Double
    var y: Double
    var oilInfo: [StationOilInfo]
    
    var isMaint: Bool {
        return _isMaint == "Y"
    }
    
    var isCarWash: Bool {
        return _isCarWash == "Y"
    }
    
    var isCertied: Bool {
        return _isCertied == "Y"
    }
    
    var isStore: Bool {
        return _isStore == "Y"
    }
    
    enum CodingKeys: String, CodingKey {
        case stationId = "UNI_ID"
        case brand = "POLL_DIV_CD"
        case gBrand = "GPOLL_DIV_CD"
        case brandName = "OS_NM"
        case addrOld = "VAN_ADR"
        case addrNew = "NEW_ADR"
        case phoneNum = "TEL"
        case regionCode = "SIGUNCD"
        case type = "LPG_YN"
        case _isMaint = "MAINT_YN"
        case _isCarWash = "CAR_WASH_YN"
        case _isCertied = "KPETRO_YN"
        case _isStore = "CVS_YN"
        case x = "GIS_X_COOR"
        case y = "GIS_Y_COOR"
        case oilInfo = "OIL_PRICE"
    }
}

struct StationOilInfo: Codable, Hashable {
    var prodcd: String
    var price: Int
    var date: String
    var time: String
    
    var oilType: OilType? {
        return OilType.allCases.first(where: { $0.resType == self.prodcd })
    }
    
    enum CodingKeys: String, CodingKey {
        case prodcd = "PRODCD"
        case price = "PRICE"
        case date = "TRADE_DT"
        case time = "TRADE_TM"
    }
}
