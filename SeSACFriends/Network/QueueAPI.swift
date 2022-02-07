//
//  QueueAPI.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/07.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum QueueAPI {
    case searchSesac(parameters: [String: Any])
}

extension QueueAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(Endpoint.baseURL)/queue")!
    }
    
    var path: String {
        switch self {
        case .searchSesac:
            return "/onqueue"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchSesac:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .searchSesac(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": AppSettings[.idToken] as? String ?? ""
        ]
    }
    
}


final class QueueNetworkingAPI {
    let provider: MoyaProvider<QueueAPI>
    
    init(provider: MoyaProvider<QueueAPI> = MoyaProvider<QueueAPI>()) {
        self.provider = provider
    }
    
    func request(_ api: QueueAPI) -> Single<Response> {
        return provider.rx.request(api)
    }
}
