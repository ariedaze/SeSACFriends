//
//  AppSettings.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/23.
//

import Foundation



@propertyWrapper
struct AppSetting<T> {
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard
    
    var wrappedValue: T {
        get {
            return container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

enum AppSettings {
    @AppSetting(key: KEY.isFirst.rawValue, defaultValue: true)
    static var isFirst: Bool
    @AppSetting(key: KEY.phoneNumber.rawValue, defaultValue: "")
    static var phoneNumber: String
    @AppSetting(key: KEY.FCMToken.rawValue, defaultValue: "")
    static var FCMToken: String
    @AppSetting(key: KEY.idToken.rawValue, defaultValue: "")
    static var idToken: String
    @AppSetting(key: KEY.matchingStatus.rawValue, defaultValue: -100)
    static var matchingStatus: Int
}


enum KEY: String, CaseIterable {
    case isFirst
    case phoneNumber
    case FCMToken
    case idToken
    case matchingStatus
}

