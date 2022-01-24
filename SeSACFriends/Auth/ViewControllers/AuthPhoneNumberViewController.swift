//
//  AuthPhoneNumberViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthPhoneNumberViewController: UIViewController {
    let viewModel = AuthPhoneViewModel()
    let disposeBag = DisposeBag()
    
    let mainView = AuthTextFieldView()
    
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
        
        // action
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc func buttonClicked() {
        viewModel.verifyPhoneNumber { result in
            switch result {
            case .success(let verificationID):
                let vc = AuthCodeViewController()
                vc.viewModel.verificationID = verificationID ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func bind(){
        mainView.textField.rx.text
            .orEmpty
            .changed
            .map { text in
                text.phoneFormat(with: "XXX-XXXX-XXXX")
            }
            .bind(to: self.mainView.textField.rx.text)
            .disposed(by: disposeBag)
        
        // input: 전화번호 입력
        mainView.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.data) // viewmodel에게 알려주기
            .disposed(by: disposeBag)

        // output:
        // 1. 번호 체크 결과 & 버튼의 상태
        viewModel.isValid()
            .map { $0 ? .fill : .disable }
            .bind(to: mainView.button.rx.status)
            .disposed(by: disposeBag)
    }
    

}
