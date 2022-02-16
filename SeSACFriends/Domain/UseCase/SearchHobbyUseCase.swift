//
//  SearchHobbyUseCase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/17.
//

import Foundation
import RxCocoa

protocol SearchHobbyUseCase {
    var validTextCount: PublishRelay<Bool> { get set }
    var validHobbyCount: PublishRelay<Bool> { get set }
    func separatedString(_ text: String)
    func validate(text: String)
    func validateCount(hobby: [String])
}


final class DefaultSearchHobbyUseCase: SearchHobbyUseCase {
    var validTextCount =  PublishRelay<Bool>()
    var validHobbyCount = PublishRelay<Bool>()
    
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
    
    func checkArrayValidity(hobby: [String]) -> Bool {
        guard hobby.count <= 8 else {
            return false
        }
        return true
    }
}
