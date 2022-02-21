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
                self?.mapUseCase.observeUserLocation()
            })
            .disposed(by: disposeBag)
        
        self.mapUseCase.authorizationStatus
            .map({ return $0 == .disallowed })
            .bind(to: output.authorizationAlertShouldShow)
            .disposed(by: disposeBag)
        
        self.mapUseCase.userLocation
            .map({ return $0 })
            .bind(to: output.mapCenterLocation)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.viewDidAppearEvent, self.mapUseCase.userLocation.asObservable())
            .map{ $1 }
            .distinctUntilChanged()
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                print("dlrjs ")
                self?.mapUseCase.onqueue(at: location)
            })
            .disposed(by: disposeBag)
        
        self.mapUseCase.onqueueResponse
            .subscribe(onNext: { response in
                output.sesacList.accept(response.fromQueueDB)
            })
            .disposed(by: disposeBag)
        
        input.mapCenterDidChanged
            .distinctUntilChanged()
            .subscribe(onNext: { location in
                print("location center 변화")
            })
            .disposed(by: disposeBag)
        
        input.gpsButtonDidTapEvent
            .map({ true })
            .bind(to: output.shouldSetCenter)
            .disposed(by: disposeBag)
        
//        input.viewWillAppear
//            .flatMap {self.networkingApi.request(.myQueueState) }
//            .filter({ response in
//                if response.statusCode == 200 { return true }
//                else if response.statusCode == 201 {
//                    print("친구 찾기 중단된 상태")
//                    self.matchedState.accept(.normal)
//                }
//                return false
//            })
//            .map(QueueState.self)
//            .subscribe(onNext: { queue in
//                if queue.matched == 0 { // 대기중.
//                    self.matchedState.accept(.matching)
//                } else {
//                    self.matchedState.accept(.matched)
//                }
//            })
//            .disposed(by: disposeBag)
        
//        input.gpsButtonTap.asObservable()
//            .flatMap { self.locationManager.requestLocation() }
//            .filter { status in
//                print(status, "filter status")
//                return true
//            }
//            .subscribe(onNext: { status in
//                if status == .notDetermined {
//
//                }
//            })
//            .disposed(by: disposeBag)


        return output
    }
}


extension MapViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewDidAppearEvent: Observable<Void>
        let mapCenterDidChanged: Observable<CLLocationCoordinate2D>
        let gpsButtonDidTapEvent: Observable<Void>
        let floatingButtonTap: ControlEvent<Void>
    }
    struct Output {
        let mapCenterLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: LocationConstant.sesacCampusCoordinateLatitude, longitude: LocationConstant.sesacCampusCoordinateLongitude))
        let authorizationAlertShouldShow = BehaviorRelay<Bool>(value: false)
        let sesacList = PublishRelay<[FromQueueDB]>()
        let matchedState = PublishRelay<MatchedState>()
//        let sceneTransition = ControlEvent<Void>(events: _)
        let shouldSetCenter = BehaviorRelay(value: true)
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude.cutNumber == rhs.latitude.cutNumber && lhs.longitude.cutNumber == rhs.longitude.cutNumber
}

extension Double {
    var cutNumber: String {
        return String(format: "%.3f", self)
    }
}
