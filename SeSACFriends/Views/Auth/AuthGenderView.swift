//
//  AuthGenderView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/23.
//

import UIKit

final class AuthGenderView: AuthCommonView {
    let manButtonView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = ColorTheme.gray3.cgColor
        return view
    }()
    let manContentView: UIView = UIView()
    let manImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "man")
        return imageview
    }()
    let manTitle: UILabel = {
        let label = UILabel()
        label.text = "남자"
        label.textAlignment = .center
        label.textColor = ColorTheme.black
        label.font = FontTheme.Title2_R16
        return label
    }()
    let manButton = UIButton()
    
    let womanButtonView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = ColorTheme.gray3.cgColor
        return view
    }()
    let womanContentView: UIView = UIView()
    let womanImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "woman")
        return imageview
    }()
    let womanTitle: UILabel = {
        let label = UILabel()
        label.text = "여자"
        label.textAlignment = .center
        label.textColor = ColorTheme.black
        label.font = FontTheme.Title2_R16
        return label
    }()
    let womanButton: UIButton = UIButton()
    
    func background(_ view: UIView, selected: Bool){
        if selected {
            view.backgroundColor = ColorTheme.whitegreen
            view.layer.borderWidth = 0
        } else {
            view.backgroundColor = ColorTheme.white
            view.layer.borderWidth = 1
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        inputFieldView.addSubview(manButtonView)
        manButtonView.addSubview(manButton)
        manButtonView.addSubview(manContentView)
        manContentView.addSubview(manImage)
        manContentView.addSubview(manTitle)
        
        inputFieldView.addSubview(womanButtonView)
        womanButtonView.addSubview(womanButton)
        womanButtonView.addSubview(womanContentView)
        womanContentView.addSubview(womanImage)
        womanContentView.addSubview(womanTitle)
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        manButtonView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        manContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        manImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        manTitle.snp.makeConstraints {
            $0.top.equalTo(manImage.snp.bottom)
            $0.trailing.leading.bottom.equalToSuperview()
        }
        manButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        womanButtonView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(manButtonView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(manButtonView.snp.width)
        }
        womanContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        womanImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        womanTitle.snp.makeConstraints {
            $0.top.equalTo(womanImage.snp.bottom)
            $0.trailing.leading.bottom.equalToSuperview()
        }
        womanButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

