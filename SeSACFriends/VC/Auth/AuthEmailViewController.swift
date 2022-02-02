//
//  AuthEmailViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/21.
//

import UIKit
import RxSwift

final class AuthEmailViewController: UIViewController {
    let mainView = AuthTextFieldView()
    let viewModel = AuthEmailViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.configure(
            titleText: "이메일을 입력해 주세요",
            descriptionText: "휴대폰 번호 변경 시 인증을 위해 사용해요"
        )
        bind()
    }
    
    private func bind() {
        let input = AuthEmailViewModel.Input(
            buttonTap: mainView.button.rx.tap.asSignal(),
            emailText: mainView.textField.rx.text)
        let output = viewModel.transform(input: input)
        
        output.validStatus
            .map { $0 ? SeSACButton.Status.fill : .disable }
            .bind(to: mainView.button.rx.status)
            .disposed(by: disposeBag)
        
        output.toastMessage
            .drive(onNext: { [unowned self] message in
                self.view.makeToast(message, position: .top)
            })
            .disposed(by: disposeBag)
        
        output.invalidTap
            .drive { a in
                print("invalid", a)
            }
            .disposed(by: disposeBag)
        
        output.validTap
            .drive { _ in
                let vc = AuthGenderViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
