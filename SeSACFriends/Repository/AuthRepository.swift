//
//  AuthRepository.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/25.
//

import Foundation
import RxSwift
import Moya

protocol AuthRepository {
    func myinfo() -> Single<Response>
    func updateFCMToken(_ token: String) -> Single<Response>
}

final class DefaultAuthRepository: AuthRepository {
    private let provider = MoyaProvider<AuthAPI>()
    
    func myinfo() -> Single<Response> {
        return provider.rx.request(.checkuser)
    }
    
    func updateFCMToken(_ token: String) -> Single<Response> {
        return provider.rx.request(.update_fcm)
    }
    
    func updateInfo() -> Single<Response> {
        let parameters = [
            "searchable": "",
            "ageMin": 0,
            "ageMax": 0,
            "gender": 0,
            "hobby": ""
        ] as [String: Any]
        
        return provider.rx.request(.update_info)
    }
}
