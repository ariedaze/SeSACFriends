//
//  AuthCodeViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/20.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa


class AuthCodeViewModel: ValidationViewModel {
    var verificationID: String = ""
    
    enum Message: String {
        case valid = "인증번호를 보냈습니다"
        case failed = "전화번호 인증 실패"
        case error = "에러가 발생했습니다. 다시 시도해주세요"
    }
    
    func validate(_ text: String) -> Bool {
        guard text.count == 6 else { // 숫자인지도 판별
            return false
        }
        return true
    }
    
    struct Input {
        let codeText: ControlProperty<String?>
        let buttonTap: Signal<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
        let verificationSuccess: Driver<String>
    }
    
    private var toastMessage = PublishRelay<String>()
    private let verificationSuccess = PublishRelay<String>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        self.toastMessage.accept(AuthCodeViewModel.Message.valid.rawValue)
        
        let _ = input.buttonTap
            .withLatestFrom(input.codeText.asDriver())
            .filter {
                if self.validate($0 ?? "") { // button tapped and valid
                    return true
                }
                self.toastMessage.accept(AuthPhoneViewModel.Message.invalid.rawValue) // button tapped and invalid
                return false
            }
            .emit { [weak self] verificationCode in
                FirebaseManager.signInWithCredential(verificationId: self?.verificationID ?? "", verificationCode: verificationCode ?? "")
                    .subscribe(onNext: {
                        self?.verificationSuccess.accept($0)
                    })
                    .disposed(by: self!.disposeBag)
            }
            .disposed(by: disposeBag)

        
        let codeValidationResult = input.codeText
            .orEmpty
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        return Output(
            validStatus: codeValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""),
            verificationSuccess: verificationSuccess.asDriver(onErrorJustReturn: "")
        )
    }

}
