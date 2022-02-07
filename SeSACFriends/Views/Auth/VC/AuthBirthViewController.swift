//
//  AuthBirthViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/21.
//

import UIKit
import RxSwift

final class AuthBirthViewController: UIViewController {
    let mainView = AuthBirthView()
    let viewModel = AuthBirthViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.configure(
            titleText: "생년월일을 알려주세요"
        )
        bind()
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func bind() {
        let input = AuthBirthViewModel.Input(
            birthDate: mainView.datePicker.rx.date,
            buttonClicked: mainView.button.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.validStatus
            .map { $0 ? SeSACButton.Status.fill : .disable }
            .bind(to: mainView.button.rx.status)
            .disposed(by: disposeBag)
        
        output.toastMessage
            .drive(onNext: { [weak self] message in
                self?.view.makeToast(message, position: .top)
            })
            .disposed(by: disposeBag)
        
        output.buttonTap
            .drive { _ in
                let vc = AuthEmailViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func buttonClicked() {
        let vc = AuthEmailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
