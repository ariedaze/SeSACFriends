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
    static private let idToken = AppSettings.idToken
    
    case searchFriends(parameters: [String: Any]) // 취미 함께할 친구 찾기 요청 (.post, /)
    case stopSearchFriends // 취미 함께할 친구 찾기 중단(.delete, /)
    case onQueue(parameters: [String: Any]) //주변새싹탐색기능 (.post, /onqueue)
    case requestHobby(parameters: [String: Any]) // 취미함께하기 요청 (.post, /hobbyrequest)
    case acceptHobby(parameters: [String: Any]) // 취미 함께하기 수락 (.post, /hobbyaccept)
    case dodge(parameters: [String: Any]) // 취미 함께하기 취소 (.post, /dodge)
    case rate(id: String, parameters: [String: Any]) // 리뷰작성 (.post, /rate/{id})
    case myQueueState // 나의 매칭상태확인 (.get, /myQueueState)
}

extension QueueAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(Endpoint.baseURL)/queue")!
    }
    
    var path: String {
        switch self {
        case .onQueue:
            return "/onqueue"
        case .requestHobby:
            return "/hobbyrequest"
        case .acceptHobby:
            return "/hobbyaccept"
        case .dodge:
            return "/dodge"
        case .rate(let id, _):
            return "/rate/\(id)"
        case .myQueueState:
            return "/myQueueState"
    
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myQueueState:
            return .get
        case .stopSearchFriends:
            return .delete
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .onQueue(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .searchFriends(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets))
        case .requestHobby(parameters: let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        case .acceptHobby(parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .dodge(parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .rate(id: _, parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": QueueAPI.idToken
        ]
    }
    
}
