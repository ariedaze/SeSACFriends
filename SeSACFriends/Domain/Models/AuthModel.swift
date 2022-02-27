//
//  AuthModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/22.
//

import Foundation

final class SignupRequest: Codable {
    static let shared = SignupRequest()
    
    var phoneNumber: String = AppSettings.phoneNumber
    var nick: String = ""
    var birth: Date = Date()
    var email: String = ""
    var gender: Int = -1
    var FCMtoken: String = AppSettings.FCMToken
    
    private init() {
        
    }
}
