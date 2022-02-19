//
//  ShopParentViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/19.
//

import UIKit

final class ShopParentViewController: UIViewController {
    let imageView = SeSACProfileImageView()
    let childVC = ShopViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        self.view.addSubview(childVC.view)
        self.addChild(childVC)
        childVC.willMove(toParent: self)
        childVC.didMove(toParent: self)

        childVC.view.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
