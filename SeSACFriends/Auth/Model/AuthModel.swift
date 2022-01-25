//
//  AuthModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/22.
//

import Foundation

struct AuthModel: Codable {
    let phoneNumber, fcmToken, nick, birth: String
    let email: String
    let gender: Int

    enum CodingKeys: String, CodingKey {
        case phoneNumber
        case fcmToken = "FCMtoken"
        case nick, birth, email, gender
    }
}
