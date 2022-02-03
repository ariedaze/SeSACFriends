//
//  AuthBirthViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/21.
//

import UIKit

final class AuthBirthViewController: UIViewController {
    let mainView = AuthBirthView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.configure(
            titleText: "생년월일을 알려주세요"
        )
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc func buttonClicked() {
        let vc = AuthEmailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
