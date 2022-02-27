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
    case checkuser
    case signup(param: SignupRequest)
    case update_fcm
    case withdraw
    case update_info
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
        case .update_info:
            return "/update/mypage"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkuser:
            return .get
        default:
            return .post
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
                    "phoneNumber" : SignupRequest.shared.phoneNumber,
                    "FCMtoken" : SignupRequest.shared.FCMtoken,
                    "nick": SignupRequest.shared.nick,
                    "birth": SignupRequest.shared.birth,
                    "email": SignupRequest.shared.email,
                    "gender" : SignupRequest.shared.gender],
                encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": AppSettings.idToken
        ]
    }
}

final class AuthNetworkingAPI {
    let provider: MoyaProvider<AuthAPI>
    
    init(provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>()) {
        self.provider = provider
    }
    
    func request(_ api: AuthAPI) -> Single<Response> {
//        dump(SignupRequest.shared)
        print("request type?", api, AppSettings.idToken)
        return provider.rx.request(api)
    }
}
