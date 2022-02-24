//
//  PrimitiveSequence+rx.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/18.
//

import Foundation
import RxMoya
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func catchSeSACNetworkError<T: SeSACNetworkError>(_ errorType: T.Type) -> Single<Element> {
        return flatMap { response in
            guard response.statusCode == 200 else {
                print("catch sesac network error: ", response.description, response.response as Any)
                do {
                    throw T(rawValue: response.statusCode as! T.RawValue) ?? errorType.defaultError()
//                    ?? T.unknownError
                } catch {
                    throw error
                }
            }
            return .just(response)
        }
    }
}

