//
//  ViewRepresentable.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/20.
//

import Foundation

protocol ViewRepresentable {
    func setUpViews()
    func setupConstraints()
    func configure(titleText:String, descriptionText: String?, buttonTitleText: String)
}

