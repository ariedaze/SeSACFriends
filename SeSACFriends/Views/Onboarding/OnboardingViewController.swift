//
//  OnboardingViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/06.
//

import UIKit
import Then
import SnapKit

class OnboardingViewController: UIViewController {
    let mainView = OnboardingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    
    @objc func buttonClicked() {
        changeRootViewControllerToPhone()
    }
}
