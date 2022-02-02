//
//  AuthModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/22.
//

import Foundation

class SignupRequest: Codable {
    static let shared = SignupRequest()
    
    var phoneNumber: String = ""
    var nick: String = ""
    var birth: String = ""
    var email: String = ""
    var gender: Int = 0
    var FCMToken: String = AppSettings[.FCMToken] as? String ?? ""
    
    private init() {
        
    }
}
