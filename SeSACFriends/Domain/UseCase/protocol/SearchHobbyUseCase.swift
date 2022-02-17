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
    func onqueue()
}
