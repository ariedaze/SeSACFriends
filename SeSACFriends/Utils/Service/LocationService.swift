//
//  SeSACLocationService.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/21.
//

import Foundation
import CoreLocation

import RxSwift
import RxCocoa

protocol LocationService {
    var authorizationStatus: BehaviorRelay<CLAuthorizationStatus> { get set }
    func requestAuthorization()
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus>
    func observeUpdatedLocation() -> Observable<[CLLocation]>
}
