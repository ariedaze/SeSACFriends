//
//  AuthNicknameViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/24.
//

import Foundation
import RxSwift
import RxCocoa

class AuthNicknameViewModel: ViewModelType, ValidationViewModel {
    var validationFailed = "닉네임은 1자 이상 10자 이내로 부탁드려요"
    var toastMessage = PublishRelay<String>()
    
    func validate(_ text: String) -> Bool {
        guard text.count >= 1 && text.count <= 10 else {
            toastMessage.accept(validationFailed)
            return false
        }
        return true
    }
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let buttonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
        let sceneTransition: ControlEvent<Void>
    }

    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let nicknameValidationResult = input.nicknameText
            .orEmpty
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        input.buttonClicked
            .filter { w in
                print(w)
                return true
            }
        
        return Output(
            validStatus: nicknameValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""),
            sceneTransition: input.buttonClicked)
    }

}

