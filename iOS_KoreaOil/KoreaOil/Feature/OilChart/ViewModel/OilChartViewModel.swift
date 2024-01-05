//
//  OilChartViewModel.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/12/23.
//

import Foundation
import Combine
import Alamofire

class OilChartViewModel: ObservableObject {
    @Published var selectedOilType: String = ""
    @Published var oilPricesData = [OilPricesInfo]()
    
    private let defaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    private let useCase = OilChartSceneUseCase()
    
    init() {
        if let oilType = defaults.string(forKey: UDOilType) {
            self.selectedOilType = oilType
        } else {
            self.selectedOilType = OilType.gasolin.rawValue
        }
    }
    
    func getChartsDatas() {
        var param = Parameters()
        param["code"] = ApiKey().free
        param["out"] = "json"
        param["prodcd"] = OilType(rawValue: selectedOilType)!.resType
        
        useCase.getOilPricesOfWeek(param)
            .asPublisher()
            .compactMap { $0.value.result.oil }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("에러요", error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] pricesInfoList in
                self?.oilPricesData = pricesInfoList
                
            }
            .store(in: &cancellables)
    }
    
    func setOilBtnSelected(_ type: OilType) {
        self.selectedOilType = type.rawValue
        defaults.set(type.rawValue, forKey: UDOilType)
        
        getChartsDatas()
    }
}
