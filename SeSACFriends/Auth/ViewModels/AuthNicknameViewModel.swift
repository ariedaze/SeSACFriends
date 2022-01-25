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
            return false
        }
        return true
    }
    
    struct Input {
        let buttonTap: Signal<Void>
        let nicknameText: ControlProperty<String?>
    }
    
    struct Output {
        let invalidTap: Driver<String?>
        let validTap: Driver<String?>
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
    }

    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // button tapped and invalid
        let invalidInputError = input.buttonTap
            .withLatestFrom(input.nicknameText.asDriver())
            .filter {
                if !self.validate($0 ?? "") {
                    self.toastMessage.accept(self.validationFailed)
                    return true
                }
                return false
            }
            .asDriver(onErrorJustReturn: "")
        
        // button tapped and valid
        let validInputResult = input.buttonTap
            .withLatestFrom(input.nicknameText.asDriver())
            .filter {
                if self.validate($0 ?? "") {
                    return true
                }
                return false
            }
            .asDriver(onErrorJustReturn: "")

        let nicknameValidationResult = input.nicknameText
            .orEmpty
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        return Output(
            invalidTap: invalidInputError,
            validTap: validInputResult,
            validStatus: nicknameValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""))
    }

}

