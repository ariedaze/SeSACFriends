//
//  SearchHobbyUseCase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/17.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultSearchHobbyUseCase: SearchHobbyUseCase {
    private let queueRepository = DefaultQueueRepository()
    private let disposeBag = DisposeBag()
    
    var validTextCount =  PublishRelay<Bool>()
    var validHobbyCount = PublishRelay<Bool>()
    var onqueueResponse = PublishSubject<QueueResponse>()
    
    func separatedString(_ text: String) {
        let hobbys = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        hobbys.forEach { self.validate(text: $0) }
        validateCount(hobby: hobbys)
    }
    
    func validate(text: String) {
        self.validTextCount.accept(checkCountValidty(text: text))
    }
    
    func validateCount(hobby: [String]) {
        self.validHobbyCount.accept(checkArrayValidity(hobby: hobby))
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
    
    func onqueue() {
        queueRepository.onqueue(lat: 37.51555287666034, long: 126.88781071074185)
            .catchOnqueueError()
            .map(QueueResponse.self)
            .subscribe { [weak self] result in
                switch result {
                case .success(let queueResponse):
                    self?.onqueueResponse.onNext(queueResponse)
                case .failure(let error):
                    print("onqueue error", error)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
