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
    func myQueueState() -> Single<Response>
    func searchFriends(type: Int, hf: [String], lat: Double, long: Double) -> Single<Response>
    func stopSearchFriends() -> Single<Response>
    func requestHobby(with uid: String) -> Single<Response>
    func acceptHobby(with uid: String) -> Single<Response>
    func cancelHobby(with uid: String) -> Single<Response>
    func rate(with uid: String, reputation: [Int], comment: String) -> Single<Response>
}

final class DefaultQueueRepository: QueueRepository {
    let provider = MoyaProvider<QueueAPI>()
    
    func myQueueState() -> Single<Response> {
        return provider.rx.request(.myQueueState)
    }
    
    // 주변 새싹 찾기
    func onqueue(lat: Double, long: Double) -> Single<Response> {
        let parameters = [
            "lat": lat, // 위도
            "long": long, // 경도
            "region": lat.lat5 * 100000 + long.long5
        ] as [String: Any]
        
        return provider.rx.request(
            .onQueue(parameters: parameters))
    }

    // 취미 함께할 새싹 찾기 시작
    func searchFriends(type: Int = 2, hf: [String] = ["Anything"], lat: Double, long: Double) -> Single<Response> {
        let parameters = [
            "type": 2,
            "lat": lat,
            "long": long,
            "region": lat.lat5 * 100000 + long.long5,
            "hf": hf
        ] as [String: Any]
        
        return provider.rx.request(.searchFriends(parameters: parameters))
    }
    
    func stopSearchFriends() -> Single<Response> {
        return provider.rx.request(.stopSearchFriends)
    }

    // 취미 함께하기 요청
    func requestHobby(with uid: String) -> Single<Response> {
        let parameters = [
            "otheruid": uid
        ] as [String: Any]
        
        return provider.rx.request(.requestHobby(parameters: parameters))
    }
    
    // 취미 함께하기 수락
    func acceptHobby(with uid: String) -> Single<Response> {
        let parameters = [
            "otheruid": uid
        ] as [String: Any]
        
        return provider.rx.request(.acceptHobby(parameters: parameters))
    }
    
    // 취미 함께하기 약속 취소
    func cancelHobby(with uid: String) -> Single<Response> {
        let parameters = [
            "otheruid": uid
        ] as [String: Any]
        
        return provider.rx.request(.dodge(parameters: parameters))
    }
    
    // 리뷰남기기
    func rate(with uid: String, reputation: [Int], comment: String) -> Single<Response> {
        let parameters = [
            "otheruid": uid,
            "reputation": reputation,
            "comment": comment,
        ] as [String: Any]
        
        return provider.rx.request(.rate(id: uid, parameters: parameters))
    }
}

