//
//  SeSACMyInfoUseCase.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/25.
//

import Foundation
import RxSwift

protocol MyInfoUseCase {
    var myinfoResponse: PublishSubject<MyInfoModel> { get set }
    func myinfo()
}

final class SeSACMyInfoUseCase: MyInfoUseCase {
    private let authRepository = DefaultAuthRepository()
    private var disposeBag = DisposeBag()
    
    var myinfoResponse = PublishSubject<MyInfoModel>()
    
    func myinfo() {
        authRepository.myinfo()
            .catchSeSACNetworkError(MyInfoError.self)
            .map(MyInfoModel.self)
            .subscribe { [weak self] result in
                switch result {
                case .success(let info):
                    self?.myinfoResponse.onNext(info)
                case .failure(let error):
                    print("auth error", error)
                }
            }
            .disposed(by: disposeBag)
    }
    
}
