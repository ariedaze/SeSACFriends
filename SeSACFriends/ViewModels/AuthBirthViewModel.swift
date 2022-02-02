//
//  AuthBirthViewModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/24.
//

import Foundation
import RxSwift
import RxCocoa

class AuthBirthViewModel: ViewModelType, ValidationViewModel {
    var validationFailed = "새싹친구는 만17세 이상만 사용할 수 있습니다."
    var toastMessage = PublishRelay<String>()
    
    func validate(_ text: String) -> Bool {
        let text = "1995/09/18"
        let age = text.toDate.age
        guard age >= 17 else { // 17이상 계산
            toastMessage.accept(validationFailed)
            return false
        }
        return true
    }
    
    struct Input {
        let birthText: ControlProperty<String?>
        let buttonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
        let sceneTransition: ControlEvent<Void>
    }

    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let birthValidationResult = input.birthText
            .orEmpty
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        return Output(
            validStatus: birthValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""),
            sceneTransition: input.buttonClicked)
    }

}

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}

extension String {
    var toDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: self)!
    }
}
