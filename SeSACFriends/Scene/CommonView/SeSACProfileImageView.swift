//
//  SeSACProfileImageView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import Foundation
import UIKit
import SwiftUI

class SeSACProfileImageView: UIView, ViewRepresentable {
    // 1. 프로필이미지
    let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .yellow
    }
    
    lazy var button: SeSACButton = {
        let button = SeSACButton()
        button.status = .fill
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews() {
        addSubview(profileImageView)
        
        addSubview(button)
    
    }
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.snp.width).multipliedBy(0.55)
        }
        button.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).offset(13)
            $0.trailing.equalTo(profileImageView.snp.trailing).offset(-13)
            $0.width.equalTo(80)
        }
    }
}
