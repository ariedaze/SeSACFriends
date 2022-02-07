//
//  AuthPhoneNumberViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class AuthPhoneNumberViewController: UIViewController {
    let mainView = AuthTextFieldView()
    
    let viewModel = AuthPhoneViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        mainView.configure(
            titleText: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요",
            buttonTitleText: "인증 문자 받기"
        )
        mainView.textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        mainView.textField.becomeFirstResponder()
    }
    
    func bind(){
        let input = AuthPhoneViewModel.Input(
            buttonTap: mainView.button.rx.tap.asSignal(),
            phoneText: mainView.textField.rx.text)
        
        let output = viewModel.transform(input: input)
        
        output.phonePattern
            .bind(to: mainView.textField.rx.text)
            .disposed(by: disposeBag)
        
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
            .drive { verificationID in
                let vc = AuthCodeViewController()
                vc.viewModel.verificationID = verificationID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

    }
    

}
