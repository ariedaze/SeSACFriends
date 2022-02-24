//
//  OnqueueError.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/18.
//

import Foundation

enum OnqueueError: Int, SeSACNetworkError {
    case tokenError = 401
    case unauthorization = 406
    case serverError = 500
    case clientError = 501
    case unknownError
    
    static func defaultError() -> OnqueueError {
        return .unknownError
    }
    
    var description: String {
        switch self {
        case .tokenError: return "Firebase Token Error"
        case .unauthorization: return "미가입 회원"
        case .serverError: return "Server Error"
        case .clientError: return "Client Error"
        case .unknownError: return "unknown error"
        }
    }
}
