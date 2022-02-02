//
//  AuthCodeView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/23.
//

import UIKit

final class AuthCodeView: AuthCommonView {
    let textField = SeSACTextField()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.green
        label.font = FontTheme.Title3_M14
        return label
    }()
    
    let resetButton: SeSACButton = {
        let button = SeSACButton()
        button.setTitle("재전송", for: .normal)
        button.size = .h40
        return button
    }()
    
    override func setUpViews() {
        super.setUpViews()
        inputFieldView.addSubview(textField)
        textField.addSubview(timeLabel)
//        inputFieldView.addSubview(timeLabel)
        inputFieldView.addSubview(resetButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(48)
        }

        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints {
            $0.leading.equalTo(textField.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(72)
            $0.bottom.equalTo(textField.snp.bottom)
        }
        
    }
}
