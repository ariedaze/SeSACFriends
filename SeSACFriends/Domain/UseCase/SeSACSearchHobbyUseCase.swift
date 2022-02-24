//
//  SeSACSearchHobbyUseCase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/17.
//

import Foundation
import RxSwift

final class SeSACSearchHobbyUseCase: SearchHobbyUseCase {
    private let queueRepository = DefaultQueueRepository()
    private let disposeBag = DisposeBag()
    
    var validTextCount =  PublishSubject<Bool>()
    var validHobbyCount = PublishSubject<Bool>()
    var onqueueResponse = PublishSubject<QueueResponse>()
    var toastMessage = PublishSubject<String>()
    var requestSuccess = PublishSubject<Bool>()
    
    func separatedString(_ text: String) {
        let hobbys = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        hobbys.forEach { self.validate(text: $0) }
        validateCount(hobby: hobbys)
    }
    
    func validate(text: String) {
        self.validTextCount.onNext(checkCountValidty(text: text))
    }
    
    func validateCount(hobby: [String]) {
        self.validHobbyCount.onNext(checkArrayValidity(hobby: hobby))
    }
    
    // 취미 1-8자리
    func checkCountValidty(text: String) -> Bool {
        guard text.count <= 8 else {
            return false
        }
        return true
    }
    
    // 취미는 8개
    func checkArrayValidity(hobby: [String]) -> Bool {
        guard hobby.count <= 8 else {
            return false
        }
        return true
    }
    
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
    
    func searchFriends(lat: Double, long: Double) {
        queueRepository.searchFriends(lat: lat, long: long)
            .catchSeSACNetworkError(QueueError.self)
            .map { $0 }
            .subscribe { [weak self] result in
                switch result {
                case .success(let _):
                    print("success")
                    self?.requestSuccess.onNext(true)
                    
                case .failure(let error):
                    self?.toastMessage.onNext(error.localizedDescription)
                    print("queue error", error)
                    self?.requestSuccess.onNext(false)
                }
            }
            .disposed(by: disposeBag)
    }
}
