//
//  QueueError.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/22.
//

import Foundation

struct QueueErrorResponse: Decodable {
    let message: String
}

enum QueueError: Int, Error {
    case reportCumulativeError = 201
    case panaltyOneMinuteError = 203
    case panaltyTwoMinuteError
    case panaltyThreeMinuteError
    case needInfoError
    case tokenError = 401
    case unauthorization = 406
    case serverError = 500
    case clientError = 501
    case unknownError
    
    var description: String {
        switch self {
        case .reportCumulativeError:
            return "신고가 누적되어 이용하실 수 없습니다"
        case .panaltyOneMinuteError:
            return "약속 취소 패널티로, 1분동안 이용하실 수 없습니다”"
        case .panaltyTwoMinuteError:
            return "약속 취소 패널티로, 2분동안 이용하실 수 없습니다”"
        case .panaltyThreeMinuteError:
            return "약속 취소 패널티로, 3분동안 이용하실 수 없습니다"
        case .needInfoError:
            return "새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!"
        case .tokenError:
            return "firebase token error"
        case .unauthorization:
            return "미가입 회원"
        case .serverError:
            return "서버에러"
        case .clientError:
            return "클라이언트"
        case .unknownError:
            return "unknownError"
        }
    }
}
