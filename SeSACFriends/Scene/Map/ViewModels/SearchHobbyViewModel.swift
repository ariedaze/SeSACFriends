//
//  SearchHobbyViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/13.
//

import Foundation
import CoreLocation

import RxSwift
import RxCocoa
import RxRelay

extension SearchHobbyViewModel {
    struct Input {
        let searchHobbyTextFieldDidEditEvent: Observable<String?>
        
    }
    struct Output {
        let toastMessage: Driver<String>
    }
}

final class SearchHobbyViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    private let searchHobbyUseCase = DefaultSearchHobbyUseCase()
    
    private let toastMessage = PublishRelay<String>()

    func transform(input: Input) -> Output {
        // 서치바
        input.searchHobbyTextFieldDidEditEvent
            .subscribe(onNext: { [weak self] hobbys in
                guard let hobbys = hobbys else {
                    return
                }
                self?.searchHobbyUseCase.separatedString(hobbys)
            })
            .disposed(by: disposeBag)

        self.searchHobbyUseCase.validTextCount
            .subscribe(onNext: { [weak self] valid in
                if !valid { self?.toastMessage.accept(ToastMessage.hobbyTextCountViolated.description) }
            })
            .disposed(by: disposeBag)
        
        self.searchHobbyUseCase
            .validHobbyCount
            .subscribe(onNext: { [weak self] valid in
                if !valid {
                    self?.toastMessage.accept(ToastMessage.hobbyTextCountViolated.description)
                }
            })
            .disposed(by: disposeBag)
        
        // 지금 주변에는
        
        return Output(
            toastMessage: self.toastMessage.asDriver(onErrorJustReturn: "")
        )
    }
}
