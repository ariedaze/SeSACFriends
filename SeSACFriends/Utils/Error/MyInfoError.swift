//
//  MyInfoError.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/25.
//

import Foundation

enum MyInfoError: Int, SeSACNetworkError {
    case tokenError = 401
    case unauthorization = 406
    case serverError = 500
    case clientError = 501
    case unknownError
    
    static func defaultError() -> MyInfoError {
        return .unknownError
    }
    
    var description: String {
        switch self {
        case .tokenError:
            return "Firebase Token Error"
        case .unauthorization:
            return "미가입회원"
        case .serverError:
            return "서버에러"
        case .clientError:
            return "클라이언트"
        case .unknownError:
            return "알수없는에러"
        }
    }
    
}
