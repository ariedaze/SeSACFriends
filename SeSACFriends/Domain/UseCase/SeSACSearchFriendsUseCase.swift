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
    var toastMessage: PublishSubject<String> { get set }
    var requestSuccess: PublishSubject<Bool> { get set }
    
    func onqueue(lat: Double, long: Double)
}


final class SeSACSearchFriendsUseCase: SearchFriendsUseCase {
    private let queueRepository = DefaultQueueRepository()
    private let disposeBag = DisposeBag()
    
    var onqueueResponse = PublishSubject<QueueResponse>()
    var toastMessage = PublishSubject<String>()
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
    
    
    
}
