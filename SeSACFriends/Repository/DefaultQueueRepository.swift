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
    
    func onqueue(lat: Double, long: Double) -> Single<Response> {
        let paramters = [
            "lat": lat, // 위도
            "long": long, // 경도
            "region": lat.lat5 * 100000 + long.long5
        ] as [String : Any]
        
        return provider.rx.request(
            .onQueue(parameters: paramters))
        
    }
    
    func queue(type: Int = 2, hf: [String]) -> Single<Response> {
        return provider.rx.request(.requestHobby)
    }
}

