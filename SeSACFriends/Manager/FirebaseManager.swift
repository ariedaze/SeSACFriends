//
//  FirebaseManager.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/24.
//

import Foundation
import FirebaseAuth

class FirebaseManager {
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
                if let error = error {
                    completion(.failure(error))
                }
                AppSettings[.idToken] = id
                completion(.success(nil))
            }
        }
    }
}
