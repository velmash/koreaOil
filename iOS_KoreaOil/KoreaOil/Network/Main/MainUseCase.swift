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
    case aroundGasStation = "/aroundAll.do"
}

class MainSceneUseCase {
    func getAroundGasStation(_ param: Parameters) -> Observable<Response<AroundGasStationResponse>> {
        return NetworkService().opinetAPIFetchable(opinetPath: MainSceneURL.aroundGasStation.rawValue, method: .get, param: param)
    }
}

