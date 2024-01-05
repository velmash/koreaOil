//
//  OilChartsResponse.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/5/24.
//

import Foundation

struct OilPriceOfWeekResponse: Codable {
    var result: OilPricesResult
    
    enum CodingKeys: String, CodingKey {
        case result = "RESULT"
    }
}

struct OilPricesResult: Codable {
    var oil: [OilPricesInfo]

    enum CodingKeys: String, CodingKey {
        case oil = "OIL"
    }
}

struct OilPricesInfo: Codable, Hashable {
    var date: String
    var prodcd: String
    var price: Double
    
    var oilType: OilType? {
        return OilType.allCases.first(where: { $0.resType == self.prodcd })
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "DATE"
        case prodcd = "PRODCD"
        case price = "PRICE"
    }
}
