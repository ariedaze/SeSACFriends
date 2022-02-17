//
//  DefaultQueueRepository.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/17.
//

import Foundation
import CoreLocation

protocol QueueRepository {
    func onqueue(location: CLLocationCoordinate2D)
}



final class DefaultQueueRepository: QueueRepository {
    private let queueNetworkService = QueueNetworkService()
    
    func onqueue(location: CLLocationCoordinate2D) {
        queueNetworkService.request(.onQueue(
            parameters: [
                "lat": location.latitude,
                "long": location.longitude,
                "region": "\(location.latitude.lat5)\(location.longitude.long5)"
                ]
        ))
    }
}
