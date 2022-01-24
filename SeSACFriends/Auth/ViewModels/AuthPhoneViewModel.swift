//
//  AuthPhoneViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/20.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxRelay

class AuthPhoneViewModel: ValidationViewModel {
    
    var validationFailed: String = "잘못된 전화번호 형식입니다."
    var data = BehaviorRelay<String>(value: "") // phone number
    var errorMessage = BehaviorRelay<String>(value: "")
    
    func isValid() -> Observable<Bool> {
        return data.map { self.validate($0) }
    }
    
    func validate(_ text: String) -> Bool {
        guard isPhonePattern(text) else {
            errorMessage.accept(validationFailed)
            return false
        }
        errorMessage.accept("")
        return true
    }
    
    func makePhonePattern(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func isPhonePattern(_ text: String) -> Bool {
        let phoneRegEx = "^\\d{3}-\\d{4}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: text)
    }
    
    
    func verifyPhoneNumber(completion: @escaping (Result<String?, Error>) -> Void) {
        let phoneNumber = "+82\(data.value.replacingOccurrences(of: "-", with: ""))"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print("error")
                    completion(.failure(error))
                    
//                    switch error.localizedDescription {
//                        case
//                    }
                    
                    return
                }
                AppSettings[.phoneNumber] = phoneNumber
                // Sign in using the verificationID and the code sent to the user
                completion(.success(verificationID))
            }
    }
}
