//
//  Service.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import Foundation
import RxSwift
import Alamofire

typealias OpinetAPIPath = String

struct NetworkService {
    static let agent = Agent()
    
    private let scheme = "http"
    private let freeUrl = "www.opinet.co.kr"
    private let path = "/api"
    
    func opinetAPIFetchable<T>(opinetPath: OpinetAPIPath, method: HTTPMethod = .post, param: [String:Any]? = nil) -> Observable<Response<T>> where T: Decodable {
        let url = self.makeAPIURL(opinetPath)
        
        let dataRequest = AF.request(url, method: method, parameters: param, encoding: method == .get ? URLEncoding.default : JSONEncoding.default)
        print("서버 요청", url)
        
        return NetworkService.agent.run(dataRequest, pathForIndicator: opinetPath)
    }
}


extension NetworkService {
    func makeAPIURL(_ functionPath: OpinetAPIPath) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = freeUrl
        components.path = path + functionPath
        
        return components
    }
}
