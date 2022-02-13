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
import Moya
import UIKit

final class AuthCodeViewModel: ValidationViewModel {
    var verificationID: String = ""
    
    enum Message: String {
        case valid = "인증번호를 보냈습니다"
        case failed = "전화번호 인증 실패"
        case error = "에러가 발생했습니다. 다시 시도해주세요"
    }
    
    func validate<T>(_ object: T) -> Bool {
        let text = object as! String
        guard text.count == 6 else { // 숫자인지도 판별
            return false
        }
        return true
    }

    let networkingApi = AuthNetworkingAPI()
    
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
                self.toastMessage.accept(AuthCodeViewModel.Message.failed.rawValue) // button tapped and invalid
                return false
            }
            .emit { [weak self] code in
                guard let self = self else {
                    return
                }
                // Todo: 이 콜백지옥 해결해보자....
                FirebaseManager.signInWithCredential(verificationId: self.verificationID, verificationCode: code ?? "")
                    .subscribe {
                        switch $0 {
                        case .success(let res):
                            print(res, "파베 성공")
                            self.networkingApi.request(.checkuser)
                                .subscribe {
                                    switch $0 {
                                    case .success(let res):
                                        switch res.statusCode {
                                        case 200:
                                            UIViewController.changeRootViewControllerToHome()
                                        default:
                                            self.verificationSuccess.accept("")
                                        }
                                    case .failure(let err):
                                        print(err, "getuser 실패")
                                    }
                                }
                                .disposed(by: self.disposeBag)
                        case .failure(_):
                            self.toastMessage.accept(AuthCodeViewModel.Message.error.rawValue)
                        }
                    }
                    .disposed(by: self.disposeBag)
                
                
            }
        
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
