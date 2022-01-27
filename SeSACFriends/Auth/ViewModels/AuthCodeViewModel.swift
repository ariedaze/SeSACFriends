//
//  AuthCodeViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/20.
//

import Foundation
import RxSwift
import RxRelay


class AuthCodeViewModel: ValidationViewModel {
    var verificationID: String = ""
    var validationFailed: String = ""
    var errorMessage = BehaviorRelay<String>(value: "")
    var data = BehaviorRelay<String>(value: "")
    
    func isValid() -> Observable<Bool> {
        return data.map { self.validate($0) }
    }
    
    func validate(_ text: String) -> Bool {
        guard data.value.count == 6 else {
            errorMessage.accept(validationFailed)
            return false
        }
        errorMessage.accept("")
        return true
    }
    func verifyCodeNumber(completion: @escaping (Result<String?, Error>) -> Void) {
        print(verificationID, "veryID!!!")
        
        FirebaseManager.signInWithCredential(
            verificationId: verificationID,
            verificationCode: data.value) { result in
            switch result {
            case .success(_):
                FirebaseManager.setIdToken { result in
                    switch result {
                    case .success(_):
                        completion(.success(nil))
                    case .failure(let error):
                        completion(.failure(error)) //토스트: 에러가 발생했습니다. 잠시 후 다시 시도해주세요
                    }
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        
    }
}
