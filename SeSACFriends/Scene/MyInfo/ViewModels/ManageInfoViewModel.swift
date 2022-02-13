//
//  ManageInfoViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/04.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import UIKit

final class ManageInfoViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    let networkingApi = AuthNetworkingAPI()

    func transform(input: Input) -> Output {
        
//        let output = input.buttonTrigger
//            .subscribe { _ in
//                self.networkingApi.request(.withdraw)
//                    .subscribe {
//                        switch $0 {
//                        case .success(let res):
//                            print("탈퇴 완료?", res)
//                            AppSettings.withdraw()
//                            UIViewController.changeRootViewControllerToPhone()
//                        case .failure(let error):
//                            print("withdraw error", error)
//                        }
//                        
//                    }
//                    .disposed(by: self.disposeBag)
//            }
//            .disposed(by: disposeBag)
//            
//        
//        
        return Output()
    }
}

extension ManageInfoViewModel {
    struct Input {
//        let buttonTrigger: ControlEvent<Void>
    }
    
    struct Output {
//        let out: Observable<Response>
    }
}
