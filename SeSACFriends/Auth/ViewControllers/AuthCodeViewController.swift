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
            .take(until: { $0 == 0 })
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
        
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func bind(){
        // input: 전화번호 입력
        mainView.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.data) // viewmodel에게 알려주기
            .disposed(by: disposeBag)

        // output:
        // 1. 코드 6자리 & 버튼의 상태
        viewModel.isValid()
            .map { $0 ? .fill : .disable }
            .bind(to: mainView.button.rx.status)
            .disposed(by: disposeBag)
    }
    
    @objc func buttonClicked() {
        viewModel.verifyCodeNumber { result in
            switch result {
            case .success(let result):
                print("베리파이코드 결과!", result)
                let vc = AuthNicknameViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
