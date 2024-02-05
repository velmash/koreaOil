//
//  RegionUseCase.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/5/24.
//

import Foundation
import RxSwift
import Alamofire

enum RegionSceneURL: OpinetAPIPath {
    case oilPriceOfWeek = "/oilPriceList.do"
}

class RegionSceneUseCase {
    func getOilPricesOfRegion(_ param: Parameters) -> Observable<Response<OilPriceOfRegionResponse>> {
        return NetworkService().opinetAPIFetchable(opinetPath: RegionSceneURL.oilPriceOfWeek.rawValue, method: .get, param: param)
    }
}
