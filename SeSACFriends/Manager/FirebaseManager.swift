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
    static func verify(phoneNumber: String?) -> Observable<String> {
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
    
    static func signInWithCredential(verificationId: String, verificationCode: String, completion: @escaping (Result<String?, Error>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("error")
                completion(.failure(error))
                return
            }
            // User is signed in
            completion(.success(nil))
        }
    }
    
    static func setIdToken(completion: @escaping (Result<String?, Error>) -> Void) {
        let user = Auth.auth().currentUser
        if let user = user {
            user.getIDToken { id, error in
                print(id, "id주세요ㅠㅠ")
                if let error = error {
                    completion(.failure(error))
                }
                AppSettings[.idToken] = id
                completion(.success(nil))
            }
        }
    }

}
