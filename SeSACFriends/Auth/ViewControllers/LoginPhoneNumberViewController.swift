//
//  File.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/18.
//

import UIKit
import SnapKit

class LoginPhoneNumberViewController: UIViewController {
    let mainView = AuthCommonView()
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.button.setTitle("인증 문자 받기", for: .normal)
        mainView.titleLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
//        mainView.descriptionLabel?.text = "하하"
    }
}
