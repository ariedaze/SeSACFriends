//
//  AuthNicknameViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/21.
//

import UIKit
import RxCocoa
import RxSwift
import Toast

final class AuthNicknameViewController: UIViewController {
    let mainView = AuthTextFieldView()
    
    let viewModel = AuthNicknameViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.configure(
            titleText: "닉네임을 입력해 주세요"
        )

        bind()
    }
    
    private func bind() {
        let input = AuthNicknameViewModel.Input(
            buttonTap: mainView.button.rx.tap.asSignal(),
            nicknameText: mainView.textField.rx.text)
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
        
        output.buttonTap
            .drive { _ in
                let vc = AuthBirthViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}

