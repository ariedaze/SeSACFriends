//
//  ToastMessage.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/17.
//

import Foundation

enum ToastMessage {
    // 취미 등록
    case hobbyTextCountViolated
    case hobbyCountViolated
    case hobbyAlreadyExist
    
    var description: String {
        switch self {
        case .hobbyTextCountViolated:
            return "최소 한 자 이상, 최대 8글자까지 작성 가능합니다"
        case .hobbyCountViolated:
            return "취미를 더 이상 추가할 수 없습니다"
        case .hobbyAlreadyExist:
            return "이미 등록된 취미입니다"
            
        }
    }
}
