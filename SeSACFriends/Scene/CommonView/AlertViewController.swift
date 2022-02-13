//
//  AlertViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/14.
//

import UIKit
import SnapKit

final class AlertViewController: UIViewController, ViewRepresentable {
    let alertView = UIView().then {
        $0.backgroundColor = ColorTheme.white
        $0.layer.cornerRadius = 16
    }
    let titleLabel = UILabel().then {
        $0.font = FontTheme.Body1_M16
        $0.textColor = ColorTheme.black
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = FontTheme.Title4_R14
        $0.textColor = ColorTheme.gray7
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let cancelButton = SeSACButton().then {
        $0.setTitle("취소", for: .normal)
        $0.status = .cancel
    }
    
    let okButton = SeSACButton().then {
        $0.setTitle("확인", for: .normal)
        $0.status = .fill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupConstraints()
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    func setUpViews() {
        view.backgroundColor = ColorTheme.black.withAlphaComponent(0.5)
        view.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(cancelButton)
        alertView.addSubview(okButton)
    }
    func setupConstraints() {
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        okButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(8)
            $0.trailing.bottom.equalToSuperview().offset(-16)
            $0.width.equalTo(cancelButton)
        }
    }
}
