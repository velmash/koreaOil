//
//  ViewModelType.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
