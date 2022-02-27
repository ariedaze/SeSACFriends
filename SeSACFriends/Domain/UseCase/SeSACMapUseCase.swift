//
//  SeSACMapUseCase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/22.
//

import Foundation
import CoreLocation

import RxSwift

final class SeSACMapUseCase: MapUseCase {
    private let queueRepository = DefaultQueueRepository()
    private let locationService = SeSSACLocationService()
    private let disposeBag = DisposeBag()
    
    var authorizationStatus = BehaviorSubject<LocationAuthorizationStatus?>(value: nil)
    var userLocation = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976))
    var onqueueResponse = PublishSubject<QueueResponse>()
    var queueState = PublishSubject<QueueState>()
    
    func checkAuthorization() {
        self.locationService.observeUpdatedAuthorization()
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    self?.authorizationStatus.onNext(.allowed)
                    self?.locationService.start()
                case .notDetermined:
                    self?.authorizationStatus.onNext(.notDetermined)
                    self?.locationService.requestAuthorization()
                case .denied, .restricted:
                    self?.authorizationStatus.onNext(.disallowed)
                @unknown default:
                    self?.authorizationStatus.onNext(nil)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func startLocationTracker() {
        self.locationService.start()
    }
    
    func stopLocationTracker() {
        self.locationService.stop()
    }
    
    func observeUserLocation() {
        return self.locationService.observeUpdatedLocation()
            .compactMap({ $0.last?.coordinate })
            .subscribe(onNext: { [weak self] location in
                self?.userLocation.onNext(location)
            })
            .disposed(by: self.disposeBag)
    }
    
    func onqueue(at location: CLLocationCoordinate2D) {
        queueRepository.onqueue(lat: location.latitude, long: location.longitude)
            .catchSeSACNetworkError(OnqueueError.self)
            .map(QueueResponse.self)
            .subscribe { [weak self] result in
                switch result {
                case .success(let queueResponse):
                    self?.onqueueResponse.onNext(queueResponse)
                case .failure(let error):
                    print("onqueue error", error)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func checkQueueStatus() {
        queueRepository.myQueueState()
            .catchSeSACNetworkError(QueueStateError.self)
            .map(QueueState.self)
            .subscribe { [weak self] result in
                switch result {
                case .success(let queueState):
                    self?.queueState.onNext(queueState)
                case .failure(let error):
                    print("queuestate error", error)
                }
            }
            .disposed(by: disposeBag)
    }
}
