//
//  SearchFriendsViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/25.
//

import Foundation
import RxSwift

final class SearchFriendsViewModel: ViewModelType {
    private let searchFriendsUseCase = SeSACSearchFriendsUseCase()
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewDidAppearEvent
            .subscribe({ [weak self] _ in
                self?.searchFriendsUseCase.onqueue(lat: LocationConstant.sesacCampusCoordinateLatitude, long: LocationConstant.sesacCampusCoordinateLongitude)
            })
            .disposed(by: disposeBag)
        
        self.searchFriendsUseCase.onqueueResponse
            .subscribe(onNext: { response in
                print("output search!!", response)
            })
            .disposed(by: disposeBag)
        
            
        return Output()
    }
    
}

extension SearchFriendsViewModel {
    struct Input {
        let viewDidAppearEvent: Observable<Void>
    }
    
    struct Output {
        
    }
}
