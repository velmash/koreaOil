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
typealias MyAPIPath = String

struct NetworkService {
    static let agent = Agent()
    
    private let schemeHTTP = "http"
    private let schemeHTTPS = "https"
    private let freeUrl = "www.opinet.co.kr"
    private let myAPIUrl = "touching-special-molly.ngrok-free.app"
    private let path = "/api"
    
    func opinetAPIFetchable<T>(isMyAPI: Bool, path: String, method: HTTPMethod = .post, param: [String:Any]? = nil) -> Observable<Response<T>> where T: Decodable {
        
        let url = isMyAPI ? self.makeMyAPIURL(path) : self.makeOpiAPIURL(path)
        
        let dataRequest = AF.request(url, method: method, parameters: param, encoding: method == .get ? URLEncoding.default : JSONEncoding.default)
        print("서버 요청", url)
        
        return NetworkService.agent.run(dataRequest, pathForIndicator: path)
    }
}


extension NetworkService {
    func makeOpiAPIURL(_ functionPath: OpinetAPIPath) -> URLComponents {
        var components = URLComponents()
        components.scheme = schemeHTTP
        components.host = freeUrl
        components.path = path + functionPath
        
        return components
    }
    
    func makeMyAPIURL(_ functionPath: MyAPIPath) -> URLComponents {
        var components = URLComponents()
        components.scheme = schemeHTTPS
        components.host = myAPIUrl
        components.path = path + functionPath
        
        return components
    }
}
