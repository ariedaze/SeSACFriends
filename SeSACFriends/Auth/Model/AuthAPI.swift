//
//  AuthAPI.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//
import UIKit
import Moya
import RxMoya
import RxSwift

enum AuthAPI {
    case signup(phone: String, nick: String)
    case update_fcm
    case withdraw
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484/user")!
    }
    
    var path: String {
        switch self {
        case .update_fcm:
            return "/update_fcm_token"
        case .withdraw:
            return "/withdraw"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup:
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
        case .signup:
            return .requestParameters(
                  parameters: [
                    "phoneNumber" : "+821099999999",
                    "FCMtoken" : "",
                    "nick": "길라다?",
                    "birth": "1995-01-01T09:23:44.054Z",
                    "email": "example@example.com",
                    "gender" : 0],
                  encoding: URLEncoding.default)
              
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": ""
        ]
    }
    
//    public var validationType: ValidationType {
//      return .successCodes
//    }

}

struct User: Decodable {
    
}

protocol NetworkingService {
    func request(_ api: AuthAPI) -> Single<[User]>
}

final class NetworkingAPI: NetworkingService {
    let provider: MoyaProvider<AuthAPI>
    
    init(provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>()) {
        self.provider = provider
    }
    
    func request(_ api: AuthAPI) -> Single<[User]> {
        return provider.rx.request(api)
            .filterSuccessfulStatusCodes()
            .map([User].self)
    }
}
