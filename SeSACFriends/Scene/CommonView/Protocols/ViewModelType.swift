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
//    func transform(input: Input, disposeBag: DisposeBag) -> Output
}

protocol ValidationViewModel {
    func validate<T>(_ object: T) -> Bool
}

