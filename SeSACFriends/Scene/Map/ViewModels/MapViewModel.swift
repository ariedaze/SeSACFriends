//
//  MapViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/08.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
import RxRelay


enum MatchedState {
    case matching
    case matched
    case normal
}

final class MapViewModel: ViewModelType {
    private let mapUseCase = SeSACMapUseCase()
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe({ [weak self] _ in
                self?.mapUseCase.checkAuthorization()
            })
            .disposed(by: disposeBag)
        
        input.viewDidAppearEvent
            .subscribe({ [weak self] _ in
                self?.mapUseCase.startLocationTracker()
                self?.mapUseCase.observeUserLocation()
                self?.mapUseCase.checkQueueStatus()
            })
            .disposed(by: disposeBag)
        
        input.viewDidDisappearEvent
            .subscribe({ [weak self] _ in
                self?.mapUseCase.stopLocationTracker()
            })
            .disposed(by: disposeBag)
        
        self.mapUseCase.userLocation
            .take(2)
            .subscribe(onNext: { location in
                print("location", location)
                output.mapCenterLocation.accept(location)
            })
            .disposed(by: disposeBag)
        
        self.mapUseCase.authorizationStatus
            .map({ return $0 == .disallowed })
            .bind(to: output.authorizationAlertShouldShow)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.gpsButtonDidTapEvent, self.mapUseCase.userLocation.asObservable())
            .map{ $1 }
            .distinctUntilChanged()
            .bind(to: output.mapCenterLocation)
            .disposed(by: disposeBag)
        
        self.mapUseCase.userLocation.asObservable()
            .distinctUntilChanged()
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                print("userLocation 변화중")
                self?.mapUseCase.onqueue(at: location)
            })
            .disposed(by: disposeBag)

        self.mapUseCase.onqueueResponse
            .subscribe(onNext: { response in
                print("output", response.fromQueueDB.count)
                output.sesacList.accept(response.fromQueueDB)
            })
            .disposed(by: disposeBag)
        
        self.mapUseCase.queueState
            .subscribe(onNext: {response in
                if response.matched == 0 {
                    output.matchedState.accept(.matching)
                } else {
                    output.matchedState.accept(.matched)
                }
                
            })
            .disposed(by: disposeBag)
        
        input.mapCenterDidChanged
            .distinctUntilChanged()
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                self?.mapUseCase.onqueue(at: location)
            })
            .disposed(by: disposeBag)
        
        input.gpsButtonDidTapEvent // 권한 설정과 묶기
            .map({ true })
            .bind(to: output.shouldSetCenter)
            .disposed(by: disposeBag)

        return output
    }
}


extension MapViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewDidAppearEvent: Observable<Void>
        let viewDidDisappearEvent: Observable<Void>
        let mapCenterDidChanged: Observable<CLLocationCoordinate2D>
        let gpsButtonDidTapEvent: Observable<Void>
        let floatingButtonTap: ControlEvent<Void>
    }
    struct Output {
        let mapCenterLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: LocationConstant.sesacCampusCoordinateLatitude, longitude: LocationConstant.sesacCampusCoordinateLongitude))
        let authorizationAlertShouldShow = BehaviorRelay<Bool>(value: false)
        let sesacList = PublishRelay<[FromQueueDB]>()
        let matchedState = PublishRelay<MatchedState>()

        let shouldSetCenter = BehaviorRelay(value: true)
    }
}

