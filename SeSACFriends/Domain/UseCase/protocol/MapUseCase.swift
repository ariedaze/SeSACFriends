//
//  MapUseCase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/21.
//

import Foundation
import CoreLocation

import RxSwift

enum LocationAuthorizationStatus {
    case allowed, disallowed, notDetermined
}

protocol MapUseCase {
    var authorizationStatus: BehaviorSubject<LocationAuthorizationStatus?> { get set }
    var userLocation: BehaviorSubject<CLLocationCoordinate2D> { get set }
    var onqueueResponse: PublishSubject<QueueResponse> {get set}
    func onqueue(at location: CLLocationCoordinate2D)
    func checkQueueStatus()
    func startLocationTracker()
    func stopLocationTracker()
    func checkAuthorization()
    func observeUserLocation()
}

