//
//  AuthGenderViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/21.
//

import UIKit

final class AuthGenderViewController: UIViewController {
    let mainView = AuthGenderView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.configure(
            titleText: "성별을 선택해 주세요",
            descriptionText: "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        )
        
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
    }
    
    @objc func buttonClicked() {
        let vc = UIViewController()
        vc.view.backgroundColor = .purple
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
