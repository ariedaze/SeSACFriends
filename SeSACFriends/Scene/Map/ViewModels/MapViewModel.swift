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

final class MapViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    private let locationManager = LocationManager.shared
    private let networkingApi = QueueNetworkingAPI()
    private let list = PublishRelay<QueueResponse>()
    private let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) //새싹 영등포 캠퍼스의 위치입니다. 여기서 시작하면 재밌을 것 같죠? 하하
    
    func transform(input: Input) -> Output {
        input.myPinLocation
            .subscribe(onNext: { location in
                let lat = location.latitude
                let long = location.longitude
                let latP = Int((lat+90)*100000)
                let longP = Int((long+180)*100000)
                
                let lat5 = latP/Int(pow(10.0, Double(latP.description.count-5)))
                let long5 = longP/Int(pow(10.0, Double(longP.description.count-5)))
                
                let paramters = [
                    "lat": location.latitude, // 위도
                    "long": location.longitude, // 경도
                    "region": lat5 * 100000 + long5
                ] as [String : Any]
                print(paramters)
                self.networkingApi.request(.searchSesac(parameters: paramters))
                    .subscribe { result in
//                        print("result", result)
                        switch result {
                        case .success(let response):
                            self.list.accept(response)
                            print("res", response.fromQueueDB.map {$0.gender})
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        return Output(
            buttonAction: input.buttonTap,
            firstLocation: sesacCoordinate,
            requestLocationAuthorization: locationManager.requestLocation(),
            sesacList: list
        )
    }
}


extension MapViewModel {
    struct Input {
        let buttonTap: Signal<Void>
        let myPinLocation: Observable<CLLocationCoordinate2D>
    }
    struct Output {
        let buttonAction: Signal<Void>
        let firstLocation: CLLocationCoordinate2D
        let requestLocationAuthorization: Observable<CLAuthorizationStatus>
        let sesacList: PublishRelay<QueueResponse>
    }
}
