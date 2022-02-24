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

final class ManageInfoViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    let myinfoUseCase = SeSACMyInfoUseCase()

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe({ [weak self] _ in
                self?.myinfoUseCase.myinfo()
            })
            .disposed(by: disposeBag)
        
        self.myinfoUseCase.myinfoResponse
            .bind(to: output.myinfo)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension ManageInfoViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let myinfo = PublishRelay<MyInfoModel>()
    }
}
