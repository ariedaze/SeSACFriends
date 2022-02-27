//
//  MyInfoViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/28.
//

import Foundation

import RxSwift
import RxCocoa

final class MyInfoViewModel: ViewModelType {
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
            .subscribe(onNext: { res in
                output.myinfo.accept(res.nick)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension MyInfoViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let myinfo = PublishRelay<String>()
    }
}
