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
        
    }
    struct Output {
        let toastMessage = PublishRelay<String>()
        let onqueueResponse = PublishRelay<QueueResponse>()
    }
}

final class SearchHobbyViewModel: ViewModelType {
    private let searchHobbyUseCase = DefaultSearchHobbyUseCase()

    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) //새싹 영등포 캠퍼스의 위치입니다. 여기서 시작하면 재밌을 것 같죠? 하하
    
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
        
        return output
    }
}
