//
//  AuthTextFieldView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/23.
//

import UIKit

final class AuthTextFieldView: AuthCommonView {
    let textField = SeSACTextField()
    
    override func setUpViews() {
        super.setUpViews()
        inputFieldView.addSubview(textField)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        textField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
}
