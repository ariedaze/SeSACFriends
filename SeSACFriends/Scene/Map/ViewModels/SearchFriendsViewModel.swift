//
//  SearchFriendsViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/25.
//

import Foundation

import RxSwift
import RxRelay

final class SearchFriendsViewModel: ViewModelType {
    private let searchFriendsUseCase = SeSACSearchFriendsUseCase()
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidAppearEvent
            .subscribe({ [weak self] _ in
                self?.searchFriendsUseCase.onqueue(lat: LocationConstant.sesacCampusCoordinateLatitude, long: LocationConstant.sesacCampusCoordinateLongitude)
                self?.searchFriendsUseCase.checkQueueStatus()
            })
            .disposed(by: disposeBag)
        
        self.searchFriendsUseCase.onqueueResponse
            .subscribe(onNext: { response in
                output.fromQueueDB.accept(response.fromQueueDB)
                output.fromQueueDBRequested.accept(response.fromQueueDBRequested)
            })
            .disposed(by: disposeBag)
        
        self.searchFriendsUseCase.queueState
            .subscribe(onNext: {  response in
                if response.matched == 1 {
                    guard let nickname = response.matchedNick else {
                        return
                    }
                    output.toastMessage.accept("\(nickname)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.")
                    output.moveToChatRoom.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        self.searchFriendsUseCase.stoppedSearch
            .subscribe(onNext: { response in
                print(response)
                if response {
                    output.toastMessage.accept("오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다")
                    output.moveToHome.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension SearchFriendsViewModel {
    struct Input {
        let viewDidAppearEvent: Observable<Void>
    }
    
    struct Output {
        let onqueueResponse = PublishRelay<QueueResponse>()
        let fromQueueDB = PublishRelay<[FromQueueDB]>()
        let fromQueueDBRequested = PublishRelay<[FromQueueDB]>()
        let matchedState = PublishRelay<MatchedState>()
        let toastMessage = PublishRelay<String>()
        let moveToChatRoom = PublishRelay<Bool>()
        let moveToHome = PublishRelay<Bool>()
    }
}
