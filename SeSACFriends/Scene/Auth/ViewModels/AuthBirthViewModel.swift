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
    enum Message: String {
        case invalid = "새싹친구는 만17세 이상만 사용할 수 있습니다."
    }

    var toastMessage = PublishRelay<String>()
    
    func validate<T>(_ object: T) -> Bool {
        let date = object as! Date
        let age = date.age
        guard age >= 17 else { // 17이상 계산
            return false
        }
        return true
    }

    struct Input {
        let birthDate: ControlProperty<Date>
        let buttonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let buttonTap: Driver<Date>
        let validStatus: Observable<Bool>
        let toastMessage: Driver<String>
    }

    var disposeBag = DisposeBag()
     
    func transform(input: Input) -> Output {

        let buttonTap = input.buttonClicked
            .withLatestFrom(input.birthDate.asDriver())
            .filter {
                if self.validate($0) { // button tapped and valid
                    SignupRequest.shared.birth = $0
                    return true
                }
                self.toastMessage.accept(AuthBirthViewModel.Message.invalid.rawValue) // button tapped and invalid
                return false
            }
            .asDriver(onErrorJustReturn: Date())
        
        let birthValidationResult = input.birthDate
            .map { self.validate($0) }
            .share(replay: 1, scope: .whileConnected)
        
        return Output(
            buttonTap: buttonTap,
            validStatus: birthValidationResult,
            toastMessage: toastMessage.asDriver(onErrorJustReturn: ""))
    }

}

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
    public var yearName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "yyyy"
        return nameFormatter.string(from: self)
    }
    public var monthName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "M"
        return nameFormatter.string(from: self)
    }
    public var dayName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "d"
        return nameFormatter.string(from: self)
    }
}

extension String {
    var toDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: self)!
    }
}
