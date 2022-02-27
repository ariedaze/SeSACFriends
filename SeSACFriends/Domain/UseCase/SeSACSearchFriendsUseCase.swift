//
//  SeSACSearchFriendsUseCase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/25.
//

import Foundation

import RxSwift

protocol SearchFriendsUseCase {
    var onqueueResponse: PublishSubject<QueueResponse> { get set }
    var queueState: PublishSubject<QueueState> { get set }
    var stoppedSearch: PublishSubject<Bool> { get set }
    var requestSuccess: PublishSubject<Bool> { get set }
    
    func onqueue(lat: Double, long: Double)
    func checkQueueStatus()
}


final class SeSACSearchFriendsUseCase: SearchFriendsUseCase {
    private let queueRepository = DefaultQueueRepository()
    private let disposeBag = DisposeBag()
    
    var onqueueResponse = PublishSubject<QueueResponse>()
    var queueState = PublishSubject<QueueState>()
    var stoppedSearch = PublishSubject<Bool>()
    var requestSuccess = PublishSubject<Bool>()
    
    func onqueue(lat: Double, long: Double) {
        queueRepository.onqueue(lat: lat, long: long)
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
            .disposed(by: disposeBag)
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
                    if error as! QueueStateError == QueueStateError.stoppedStateError {
                        self?.stoppedSearch.onNext(true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
