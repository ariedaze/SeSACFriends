//
//  FirebaseManager.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/24.
//

import Foundation
import FirebaseAuth
import RxSwift

class FirebaseManager {
    enum error: String {
        case TOO_MANY_REQUESTS = "We have blocked all requests from this device due to unusual activity. Try again later."
    }
    static func verify(phoneNumber: String?) -> Observable<String> { // 전화번호 인증
        let phoneNumber = "+82\(phoneNumber!.replacingOccurrences(of: "-", with: ""))"
        return Observable.create { observer in
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        observer.onError(error)
                    }
                    observer.onNext(verificationID ?? "")
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }
    
    static func signInWithCredential(verificationId: String, verificationCode: String) -> Single<String> { // 6자리 코드
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode
        )
        
        return Single.create { single in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    single(.failure(error))
                }
                single(.success(""))
            }
            return Disposables.create()
        }
    }
    
    static func setIdToken() -> Single<String> {
        let user = Auth.auth().currentUser
        return Single.create { single in
            if let user = user {
                user.getIDToken { id, error in
                    print(id, "id주세요ㅠㅠ")
                    if let error = error {
                        single(.failure(error))
                    }
                    AppSettings[.idToken] = id
                    single(.success(id ?? ""))
                }
                
            }
            return Disposables.create()
        }
    }

}
