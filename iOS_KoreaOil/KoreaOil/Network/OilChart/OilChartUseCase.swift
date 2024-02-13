//
//  OilChartUseCase.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/5/24.
//

import Foundation
import RxSwift
import Alamofire

enum OilChartSceneURL: OpinetAPIPath {
    case oilPriceOfWeek = "/avgRecentPrice.do"
}

class OilChartSceneUseCase {
    func getOilPricesOfWeek(_ param: Parameters) -> Observable<Response<OilPriceOfWeekResponse>> {
        return NetworkService().opinetAPIFetchable(isMyAPI: false, path: OilChartSceneURL.oilPriceOfWeek.rawValue, method: .get, param: param)
    }
}
