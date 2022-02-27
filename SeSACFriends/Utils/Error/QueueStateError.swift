//
//  QueueStateError.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/28.
//

import Foundation


enum QueueStateError: Int, SeSACNetworkError {
    case stoppedStateError = 201
    case tokenError = 401
    case unauthorization = 406
    case serverError = 500
    case clientError = 501
    case unknownError
    
    static func defaultError() -> QueueStateError {
        return .unknownError
    }
    
    var description: String {
        switch self {
        case .stoppedStateError: return "오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다"
        case .tokenError: return "Firebase Token Error"
        case .unauthorization: return "미가입 회원"
        case .serverError: return "Server Error"
        case .clientError: return "Client Error"
        case .unknownError: return "unknown error"
        }
    }
}
