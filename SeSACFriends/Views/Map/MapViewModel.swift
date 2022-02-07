//
//  MapViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/08.
//

import Foundation
import RxSwift

class MapViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        return Output()
    }
}


extension MapViewModel {
    struct Input {}
    struct Output {}
}
