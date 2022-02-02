//
//  AuthGenderViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/24.
//

import Foundation
import RxSwift
import RxCocoa

class AuthGenderViewModel: ViewModelType {
    var toastMessage = PublishRelay<String>()
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let buttonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let toastMessage: Driver<String>
        let sceneTransition: ControlEvent<Void>
    }

    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let nicknameValidationResult = input.nicknameText
            .orEmpty
            .share(replay: 1, scope: .whileConnected)
        
        return Output(
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""),
            sceneTransition: input.buttonClicked)
    }

}

