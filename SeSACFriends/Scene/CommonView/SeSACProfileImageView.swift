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
        $0.clipsToBounds = true
    }
    
    let sesacImageView = UIImageView()
    
    lazy var button: SeSACButton = {
        let button = SeSACButton()
        button.status = .fill
        button.size = .h40
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
        addSubview(sesacImageView)
        addSubview(button)
    
    }
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.snp.width).multipliedBy(0.55)
        }
        sesacImageView.snp.makeConstraints {
            $0.width.height.equalTo(profileImageView.snp.height)
            $0.centerY.equalTo(profileImageView).offset(16)
            $0.centerX.equalTo(profileImageView)
        }
        button.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).offset(13)
            $0.trailing.equalTo(profileImageView.snp.trailing).offset(-13)
            $0.width.equalTo(80)
        }
    }
}
