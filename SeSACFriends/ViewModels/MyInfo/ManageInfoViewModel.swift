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

class ManageInfoViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    let networkingApi = AuthNetworkingAPI()

    func transform(input: Input) -> Output {
        
        let output = input.buttonTrigger
            .asObservable()
            .flatMapLatest {
                self.networkingApi.request(.withdraw)
                    .do(onError: { [weak self] error in
                        print("error")
                    })
            }
        
        
        return Output(out: output)
    }
}

extension ManageInfoViewModel {
    struct Input {
        let buttonTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let out: Observable<Response>
    }
}
