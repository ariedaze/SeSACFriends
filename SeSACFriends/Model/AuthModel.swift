//
//  AuthModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/22.
//

import Foundation

class SignupRequest: Codable {
    static let shared = SignupRequest()
    
    var phoneNumber: String = AppSettings[.phoneNumber] as? String ?? ""
    var nick: String = "ariee"
    var birth: String = "1990-01-16T09:23:44.054Z"
    var email: String = "a123@aaa.com"
    var gender: Int = 0
    var FCMtoken: String = AppSettings[.FCMToken] as? String ?? ""
    
    private init() {
        
    }
}
