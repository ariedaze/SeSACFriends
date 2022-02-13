//
//  SearchHobbyViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/13.
//

import Foundation
import RxSwift
import CoreLocation

class SearchHobbyViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976)
    
    let networkingApi = QueueNetworkingAPI()
    

    func transform(input: Input) -> Output {
        
        let paramters = [
            "lat": sesacCoordinate.latitude, // 위도
            "long": sesacCoordinate.longitude, // 경도
            "region": sesacCoordinate.latitude.lat5 * 100000 + sesacCoordinate.longitude.long5
        ] as [String : Any]
        
        
        self.networkingApi.request(.searchSesac(parameters: paramters))
            .map(QueueResponse.self)
            .subscribe { result in
//                        print("result", result)
                switch result {
                case .success(let response):
//                    self.list.accept(response)
                    print("res", response.fromQueueDB.map {$0.gender})
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: self.disposeBag)
        
        return Output()
    }
}

extension SearchHobbyViewModel {
    struct Input {
        
    }
    struct Output {
        let sectionTitles = ["지금 주변에는", "내가 하고 싶은"]
    }
}
