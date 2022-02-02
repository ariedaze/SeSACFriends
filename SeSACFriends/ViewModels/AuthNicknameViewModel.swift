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
    enum Message: String {
        case invalid = "닉네임은 1자 이상 10자 이내로 부탁드려요"
        case failed = "해당 닉네임은 사용할 수 없습니다"
    }
    
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
        let buttonTap: Driver<String?>
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
    }
    private var toastMessage = PublishRelay<String>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let buttonTap = input.buttonTap
            .withLatestFrom(input.nicknameText.asDriver())
            .filter {
                if self.validate($0 ?? "") { // button tapped and valid
                    SignupRequest.shared.nick = $0 ?? ""
                    return true
                }
                self.toastMessage.accept(AuthNicknameViewModel.Message.invalid.rawValue) // button tapped and invalid
                return false
            }
            .asDriver(onErrorJustReturn: "")

        let nicknameValidationResult = input.nicknameText
            .orEmpty
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        return Output(
            buttonTap: buttonTap,
            validStatus: nicknameValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""))
    }

}

