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
    @Published var weekPriceData = [AvgAllPrice]()
    var cancellables = Set<AnyCancellable>()
    
    let useCase = MainSceneUseCase()
    
    init() { }
    
    func getParam() {
        var param = Parameters()
        param["code"] = ApiKey().free
        param["out"] = "json"
        
        useCase.getAvgAllPrice(param)
            .asPublisher()
            .compactMap { $0.value.result.oil }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Ddd", error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] avgList in
                print("HIHIHI", avgList)
                self?.weekPriceData = avgList
            }
            .store(in: &cancellables)
    }
}
