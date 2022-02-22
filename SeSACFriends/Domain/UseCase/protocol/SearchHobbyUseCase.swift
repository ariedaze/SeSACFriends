//
//  SearchHobbyUseCase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/17.
//

import Foundation
import RxSwift

protocol SearchHobbyUseCase {
    var validTextCount: PublishSubject<Bool> { get set }
    var validHobbyCount: PublishSubject<Bool> { get set }
    var onqueueResponse: PublishSubject<QueueResponse> { get set }
    var toastMessage: PublishSubject<String> { get set }
    var requestSuccess: PublishSubject<Bool> { get set }
    
    func separatedString(_ text: String)
    func validate(text: String)
    func validateCount(hobby: [String])
    func checkCountValidty(text: String) -> Bool
    func checkArrayValidity(hobby: [String]) -> Bool
    
    func onqueue(lat: Double, long: Double)
    func searchFriends(lat: Double, long: Double)
}
