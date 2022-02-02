//
//  AuthCommonView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/19.
//

import UIKit
import SnapKit

class AuthCommonView: UIView, ViewRepresentable {
    let labelView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.distribution = .fillProportionally
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontTheme.Display1_R20
        label.textColor = ColorTheme.black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel? = {
        let label = UILabel()
        label.font = FontTheme.Title2_R16
        label.textColor = ColorTheme.gray7
        label.textAlignment = .center
        return label
    }()
    
    let inputFieldView = UIView()
    
    let button: SeSACButton = {
        let button = SeSACButton()
        button.size = .h48
        button.status = .disable
        return button
    }()

    let containerView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 32
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(titleText: String, descriptionText: String? = nil, buttonTitleText: String = "다음") {
        button.setTitle(buttonTitleText, for: .normal)
        titleLabel.text = titleText
        descriptionLabel?.text = descriptionText
    }
    
    func setUpViews() {
        self.backgroundColor = .white
        self.addSubview(containerView)
        
        containerView.addArrangedSubview(labelView)
        labelView.addArrangedSubview(titleLabel)
        

        containerView.addArrangedSubview(inputFieldView)
        containerView.addArrangedSubview(button)
        
        if let descriptionLabel = descriptionLabel {
            labelView.addArrangedSubview(descriptionLabel)
        }
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.7)
        }
        labelView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        descriptionLabel?.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        inputFieldView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.leading.trailing.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
