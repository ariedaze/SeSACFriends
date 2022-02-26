//
//  AuthModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/22.
//

import Foundation

final class SignupRequest: Codable {
    static let shared = SignupRequest()
    
    var phoneNumber: String = AppSettings.phoneNumber as? String ?? ""
    var nick: String = "ariee"
    var birth: Date = Date()
    var email: String = "a123@aaa.com"
    var gender: Int = 0
    var FCMtoken: String = AppSettings.FCMToken as? String ?? ""
    
    private init() {
        
    }
}
