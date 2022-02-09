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

class MapViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    let locationManager = LocationManager.shared
    let networkingApi = QueueNetworkingAPI()
    
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) //새싹 영등포 캠퍼스의 위치입니다. 여기서 시작하면 재밌을 것 같죠? 하하
    
    func transform(input: Input) -> Output {
        input.myPinLocation
            .subscribe(onNext: { t in
                let paramters = [
                    "lat": t.latitude, // 위도
                    "long": t.longitude, // 경도
                    "region": Int(((t.latitude+90)*100000).truncatingRemainder(dividingBy: 100000)*100000+((t.longitude+180)*100000).truncatingRemainder(dividingBy: 100000))
                ] as [String : Any]
                
                self.networkingApi.request(.searchSesac(parameters: paramters))
                    .subscribe { result in
//                        print("result", result)
                        switch result {
                        case .success(let response):
                            print("res", response)
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        return Output(
            buttonAction: input.buttonTap,
            firstRequest: locationManager.requestLocation()
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
        let firstRequest: Observable<CLAuthorizationStatus>
    }
}
