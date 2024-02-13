//
//  RegionUseCase.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/5/24.
//

import Foundation
import RxSwift
import Alamofire

enum RegionSceneMyURL: MyAPIPath {
    case regionGeo = "/regions"
}

class RegionSceneUseCase {
    func requestRegionStationDetailInfo(_ param: Parameters) -> Observable<Response<StationDetailResponseOnRegion>> {
        return NetworkService().opinetAPIFetchable(isMyAPI: true, path: RegionSceneMyURL.regionGeo.rawValue, method: .get, param: param)
    }
}
