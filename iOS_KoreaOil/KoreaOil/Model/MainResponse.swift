//
//  MainResponse.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation

struct AvgAllPriceResponse: Codable {
    var result: Result

    enum CodingKeys: String, CodingKey {
        case result = "RESULT"
    }
}

struct Result: Codable {
    var oil: [AvgAllPrice]

    enum CodingKeys: String, CodingKey {
        case oil = "OIL"
    }
}

struct AvgAllPrice: Codable, Hashable {
    var tradeDt: String
    var prodcd: String
    var prodnm: String
    var price: String
    var diff: String

    enum CodingKeys: String, CodingKey {
        case tradeDt = "TRADE_DT"
        case prodcd = "PRODCD"
        case prodnm = "PRODNM"
        case price = "PRICE"
        case diff = "DIFF"
    }
}
