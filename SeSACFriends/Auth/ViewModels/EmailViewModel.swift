//
//  EmailViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/22.
//

import Foundation
import RxSwift
import RxCocoa

class EmailViewModel: ViewModelType, ValidationViewModel {
    var validationFailed = "이메일 형식이 올바르지 않습니다."
    var toastMessage = PublishRelay<String>()
    
    func validate(_ text: String) -> Bool {
        guard isPhonePattern(text: text) else {
            toastMessage.accept(validationFailed)
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
        let emailText: ControlProperty<String?>
        let buttonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
        let sceneTransition: ControlEvent<Void>
    }

    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let emailValidationResult = input.emailText
            .orEmpty
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        return Output(
            validStatus: emailValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""),
            sceneTransition: input.buttonClicked)
    }

}
