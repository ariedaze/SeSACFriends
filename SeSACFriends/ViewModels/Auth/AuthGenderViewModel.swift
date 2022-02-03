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

class AuthGenderViewModel: ViewModelType {
    enum Message: String {
        case error = "에러가 발생했습니다. 잠시 후 다시 시도해주세요"
    }
    private var toastMessage = PublishRelay<String>()
    private var selectedGender = -1
    
    var disposeBag = DisposeBag()
    let networkingApi = NetworkingAPI()
    
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
        
        let output = input.buttonTrigger
            .asObservable()
            .flatMapLatest {
                self.networkingApi.request(.signup(param: SignupRequest.shared))
                    .do(onError: { [weak self] error in
                        print("error")
                    })
            }


        return Output(
            buttonTap: source,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""),
            out: output
        )
    }

}

extension AuthGenderViewModel {
    struct Input {
        let buttonTrigger: ControlEvent<Void>
        let manButtonTap: Signal<Void>
        let womanButtonTap: Signal<Void>
//        let nextButtonTap: Signal<Void>
    }
    
    struct Output {
        let buttonTap: Observable<Int>
        let toastMessage: Driver<String>
        let out: Observable<Response>
    }
}
