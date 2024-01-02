//
//  MainUseCase.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation
import RxSwift
import Alamofire

enum MainSceneURL: OpinetAPIPath {
    case avgAllPrice = "/avgAllPrice.do"
}

class MainSceneUseCase {
    func getAvgAllPrice(_ param: Parameters) -> Observable<Response<AvgAllPriceResponse>> {
        return NetworkService().opinetAPIFetchable(opinetPath: MainSceneURL.avgAllPrice.rawValue, method: .get, param: param)
    }
    
//    private func requestWithApiKey(_ param: Parameters, _ path: String) -> Observable<Response<[AvgAllPrice]>> {
//        var mutableParam = param
//        mutableParam["code"] = ApiKey().free
//        return NetworkService().opinetAPIFetchable(opinetPath: path, method: .get, param: mutableParam)
//    }
}

