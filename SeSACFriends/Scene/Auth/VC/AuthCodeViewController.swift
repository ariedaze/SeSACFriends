//
//  AuthCodeViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/20.
//

import UIKit
import RxSwift
import Toast

extension Int {
    var times: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: Double(self)) ?? ""
    }
}

final class AuthCodeViewController: UIViewController {
    let viewModel = AuthCodeViewModel()
    let mainView = AuthCodeView()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countdown = 60
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { countdown - $0 }
            .take(until: { $0 == -1 })
            .subscribe(onNext: { value in
                self.mainView.timeLabel.text = value.times
            }, onCompleted: {
                print("completed")
                self.view.makeToast("전화번호 인증 실패")
            }).disposed(by: disposeBag)
        
        mainView.configure(
            titleText: "인증번호가 문자로 전송되었어요",
            descriptionText: "최대 소모 20초",
            buttonTitleText: "인증하고 시작하기"
        )
        mainView.textField.placeholder = "인증번호 입력"
        
        bind()
        
        addTapGestureForKeyboard()
    }

    func bind(){
        let input = AuthCodeViewModel.Input(
            codeText: mainView.textField.rx.text,
            buttonTap: mainView.button.rx.tap.asSignal())
        
        let output = viewModel.transform(input: input)
        
        output.validStatus
            .map {$0 ? SeSACButton.Status.fill : .disable}
            .bind(to: mainView.button.rx.status)
            .disposed(by: disposeBag)
        
        output.validStatus
            .map {$0 ? .active : self.mainView.textField.status}
            .bind(to: mainView.textField.rx.status)
            .disposed(by: disposeBag)
        
        output.toastMessage
            .drive(onNext: { [weak self] message in
                self?.view.makeToast(message, position: .top)
            })
            .disposed(by: disposeBag)
        
        output.verificationSuccess
            .drive { _ in
                let vc = AuthNicknameViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
