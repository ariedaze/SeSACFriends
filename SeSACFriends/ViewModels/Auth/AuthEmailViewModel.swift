//
//  AuthEmailViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/22.
//

import Foundation
import RxSwift
import RxCocoa

class AuthEmailViewModel: ViewModelType, ValidationViewModel {
    var validationFailed = "이메일 형식이 올바르지 않습니다."
    var toastMessage = PublishRelay<String>()
    
    func validate<T>(_ object: T) -> Bool {
        let text = object as! String
        guard isPhonePattern(text: text) else {
            return false
        }
        return true
    }
    
    func isPhonePattern(text : String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    struct Input {
        let buttonTap: Signal<Void>
        let emailText: ControlProperty<String?>
    }
    
    struct Output {
        let validTap: Driver<String?>
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
    }

    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // button tapped and valid
        let validInputResult = input.buttonTap
            .withLatestFrom(input.emailText.asDriver())
            .filter {
                if self.validate($0 ?? "") {
                    SignupRequest.shared.email = $0 ?? ""
                    return true
                }
                self.toastMessage.accept(self.validationFailed)
                return false
            }
            .asDriver(onErrorJustReturn: "")

        let emailTextValidationResult = input.emailText
            .orEmpty
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        return Output(
            validTap: validInputResult,
            validStatus: emailTextValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""))
    }

}
