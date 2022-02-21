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
        let viewDidLoadEvent: Observable<Void>
        let searchHobbyTextFieldDidEditEvent: Observable<String?>
        let searchButtonTapEvent: Observable<Void>
    }
    struct Output {
        let toastMessage = PublishRelay<String>()
        let onqueueResponse = PublishRelay<QueueResponse>()
    }
}

final class SearchHobbyViewModel: ViewModelType {
    private let searchHobbyUseCase = SeSACSearchHobbyUseCase()
    
    // remove
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
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
            .subscribe(onNext: { valid in
                if !valid { output.toastMessage.accept(ToastMessage.hobbyTextCountViolated.description) }
            })
            .disposed(by: disposeBag)
        
        self.searchHobbyUseCase
            .validHobbyCount
            .subscribe(onNext: { valid in
                if !valid {
                    output.toastMessage.accept(ToastMessage.hobbyTextCountViolated.description)
                }
            })
            .disposed(by: disposeBag)
        
        // 지금 주변에는
        input.viewDidLoadEvent
            .subscribe({ [weak self] _ in
                self?.searchHobbyUseCase.onqueue()
            })
            .disposed(by: disposeBag)
        
        self.searchHobbyUseCase.onqueueResponse
            .bind(to: output.onqueueResponse)
            .disposed(by: disposeBag)
        
        // searchbutton
        input.searchButtonTapEvent
            .subscribe({ _ in
                print("tap")
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
