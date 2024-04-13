//
//  Bundle+Extension.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/21/24.
//

import Foundation

extension Bundle {
    func value<T>(for key: String) -> T? {
        return object(forInfoDictionaryKey: key) as? T
    }
}
