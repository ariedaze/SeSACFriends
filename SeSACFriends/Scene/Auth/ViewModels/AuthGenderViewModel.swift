//
//  AuthGenderViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/24.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class AuthGenderViewModel: ViewModelType {
    enum Message: String {
        case error = "에러가 발생했습니다. 잠시 후 다시 시도해주세요"
    }
    private var toastMessage = PublishRelay<String>()
    private var successSignup = PublishRelay<Bool>()
    private var selectedGender = -1
    
    var disposeBag = DisposeBag()
    let networkingApi = AuthNetworkingAPI()
    
    func transform(input: Input) -> Output {
        
        let source = Observable.of(
            input.manButtonTap.map { () -> Int in
                if self.selectedGender == 1 {
                    self.selectedGender = -1
                } else {
                    self.selectedGender = 1
                }
                return 1
            }, input.womanButtonTap.map{
                if self.selectedGender == 0 {
                    self.selectedGender = -1
                } else {
                    self.selectedGender = 0
                }
                return 0
            })
            .merge()
        
        input.buttonTrigger
            .emit { [weak self] _ in
                SignupRequest.shared.gender = self?.selectedGender ?? -2
                self?.networkingApi.request(.signup(param: SignupRequest.shared))
                    .subscribe { event in
                        switch event {
                        case .success(let response):
                            print("res", response.statusCode)
                            self?.successSignup.accept(true)
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .disposed(by: self!.disposeBag)
            }
            .disposed(by: disposeBag)

        return Output(
            buttonTap: source,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""),
            success: successSignup.asDriver(onErrorJustReturn: false)
        )
    }

}

extension AuthGenderViewModel {
    struct Input {
        let buttonTrigger: Signal<Void>
        let manButtonTap: Signal<Void>
        let womanButtonTap: Signal<Void>
    }
    
    struct Output {
        let buttonTap: Observable<Int>
        let toastMessage: Driver<String>
        let success: Driver<Bool>
    }
}
