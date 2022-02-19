//
//  DefaultQueueRepository.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/17.
//

import Foundation
import RxSwift
import Moya

protocol QueueRepository {
    func onqueue(lat: Double, long: Double) -> Single<Response>
}

final class DefaultQueueRepository: QueueRepository {
    let provider = MoyaProvider<QueueAPI>()
    
    // 주변 새싹 찾기
    func onqueue(lat: Double, long: Double) -> Single<Response> {
        let paramters = [
            "lat": lat, // 위도
            "long": long, // 경도
            "region": lat.lat5 * 100000 + long.long5
        ] as [String: Any]
        
        return provider.rx.request(
            .onQueue(parameters: paramters))
        
    }
    
    // 취미 요청하기
    func requestHobby(type: Int = 2, hf: [String], lat: Double, long: Double) -> Single<Response> {
        let paramter = [
            "type": 2,
            "lat": lat,
            "long": long,
            "region": lat.lat5 * 100000 + long.long5,
            "hf": ["anything"]
        ] as [String: Any]
        
        return provider.rx.request(.requestHobby)
    }

}

