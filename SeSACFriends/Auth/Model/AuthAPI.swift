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
    case signup
    case update_fcm
    case withdraw
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484/user")!
    }
    
    var path: String {
        switch self {
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
    
    var task: Task {
        switch self {
        case let .signup:
            return .requestPlain
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }

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
