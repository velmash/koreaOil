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
}
