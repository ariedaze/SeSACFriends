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
    func catchOnqueueError() -> Single<Element> {
        return flatMap { response in
            guard response.statusCode == 200 else {
                print("catch onqueue error: ", response.description, response.response)
                do {
                    throw OnqueueError(rawValue: response.statusCode) ?? OnqueueError.unknownError
                } catch {
                    throw error
                }
            }
            return .just(response)
        }
    }
    

}
