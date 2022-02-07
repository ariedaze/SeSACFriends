//
//  LocationPermissionManager.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

class LocationManager {
    static let shared = LocationManager()
    private let disposeBag = DisposeBag()
    
    let locationSubject = BehaviorSubject<CLLocationCoordinate2D?>(value: nil)
    
    private let locationManager: CLLocationManager = { // 권한, 실시간 위치 정보 매니저
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }()
    
    private init() {
        // Bind Location
        self.locationManager.rx.didUpdateLocations // 실시간위치 구독하여 locationSubject에 입력
            .compactMap(\.locations.last?.coordinate)
            .bind(onNext: self.locationSubject.onNext(_:))
            .disposed(by: self.disposeBag)
        self.locationManager.startUpdatingLocation() // 이미 권한을 허용한 경우 케이스 대비
        
    }

    // 위치 권한 요청
    func requestLocation() -> Observable<CLAuthorizationStatus> {
        return Observable<CLAuthorizationStatus>
            .deferred { [weak self] in // Observable 지연 생성자, 내부에서 다른 Observable을 리턴할 때 사용
                guard let ss = self else { return .empty() }
                ss.locationManager.requestWhenInUseAuthorization()
                return ss.locationManager.rx.didChangeAuthorization // 위치 권한을 선택한 후 Observable 리턴
                    .map { $1 }
                    .filter { $0 != .notDetermined }
                    .do(onNext: { _ in ss.locationManager.startUpdatingLocation() })
                    .take(1)
            }
    }
}

