//
//  AuthPhoneViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/20.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
import RxRelay

class AuthPhoneViewModel: ValidationViewModel, ViewModelType {
    enum Message: String {
        case valid = "전화 번호 인증 시작"
        case invalid = "잘못된 전화번호 형식입니다."
        case exceed = "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
        case error = "에러가 발생했습니다. 다시 시도해주세요"
    }

    var toastMessage = PublishRelay<String>()

    func validate<T>(_ object: T) -> Bool {
        let text = object as! String
        guard isPhonePattern(text) else {
            return false
        }
        return true
    }

    func makePhonePattern(phone: String) -> String {
        let mask = "XXX-XXXX-XXXX"
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func isPhonePattern(_ text: String) -> Bool {
        let phoneRegEx = "^\\d{3}-\\d{4}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: text)
    }

    struct Input {
        let buttonTap: Signal<Void>
        let phoneText: ControlProperty<String?>
    }
    
    struct Output {
        let phonePattern: Observable<String>
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
        let verificationSuccess: Driver<String>
    }
    private let verificationSuccess = PublishRelay<String>()
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.buttonTap
            .withLatestFrom(input.phoneText.asDriver())
            .filter {
                if self.validate($0 ?? "") { // button tapped and valid
                    self.toastMessage.accept(AuthPhoneViewModel.Message.valid.rawValue)
                    return true
                }
                self.toastMessage.accept(AuthPhoneViewModel.Message.invalid.rawValue) // button tapped and invalid
                return false
            }
            .emit { [weak self] res in
                AppSettings[.phoneNumber] = res
                FirebaseManager.verify(phoneNumber: res)
                    .subscribe(onNext: {
                        self?.verificationSuccess.accept($0)
                    }, onError: { error in
                        if error.localizedDescription == FirebaseManager.error.TOO_MANY_REQUESTS.rawValue {
                            self?.toastMessage.accept(AuthPhoneViewModel.Message.exceed.rawValue)
                        } else {
                            self?.toastMessage.accept(AuthPhoneViewModel.Message.error.rawValue)
                        }
                    })
                    .disposed(by: self!.disposeBag)
            }
            .disposed(by: disposeBag)

        let phoneValidationResult = input.phoneText
            .orEmpty
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        let phonePattern = input.phoneText
            .orEmpty
            .map { self.makePhonePattern(phone: $0) }

        return Output(
            phonePattern: phonePattern,
            validStatus: phoneValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""),
            verificationSuccess: verificationSuccess.asDriver(onErrorJustReturn: "")
        )
    }

}
