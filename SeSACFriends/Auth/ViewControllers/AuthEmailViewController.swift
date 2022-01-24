//
//  AuthEmailViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/21.
//

import UIKit

final class AuthEmailViewController: UIViewController {
    let mainView = AuthTextFieldView()
    
    override func loadView() {
        self.view = mainView
        
        mainView.configure(
            titleText: "이메일을 입력해 주세요",
            descriptionText: "휴대폰 번호 변경 시 인증을 위해 사용해요"
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc func buttonClicked() {
        let vc = AuthGenderViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
