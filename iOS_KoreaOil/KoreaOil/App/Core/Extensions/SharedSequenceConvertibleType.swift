//
//  SharedSequenceConvertibleType.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import RxSwift
import RxCocoa

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    func doOnNext(_ onNext: @escaping (Element) -> Void) -> Driver<Element> {
        return self.do(onNext: onNext)
    }
    
    func doOnCompleted(_ onCompleted: @escaping () -> Void) -> Driver<Element> {
        return self.do(onCompleted: onCompleted)
    }

    func driveNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return self.drive(onNext: onNext)
    }

    func driveCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return self.drive(onCompleted: onCompleted)
    }
}
