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

struct Endpoint {
    static let baseURL = "http://test.monocoding.com:35484"
}

enum AuthAPI {
    case signup(param: SignupRequest)
    case update_fcm
    case withdraw
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(Endpoint.baseURL)/user")!
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
        case .signup(let param):
            return .requestJSONEncodable(param)
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