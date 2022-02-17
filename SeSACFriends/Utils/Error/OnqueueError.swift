//
//  OnqueueError.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/18.
//

import Foundation

struct OnqueueErrorResponse: Decodable {
    let message: String
}

enum OnqueueError: Int, Error {
    case tokenError = 401
    case unauthorization = 406
    case serverError = 500
    case clientError = 501
    case unknownError
    
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
