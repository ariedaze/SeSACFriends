//
//  ViewModelProtocol.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/24.
//

import Foundation
import RxSwift
import RxRelay

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}

protocol ValidationViewModel {
    func validate(_ text: String) -> Bool
}

