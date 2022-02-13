//
//  HobbyCollectionHeaderView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/14.
//

import UIKit

class HobbyCollectionHeaderView: UICollectionReusableView, Reusable {
    let titleLabel = UILabel().then {
        $0.font = FontTheme.Title6_R12
        $0.textColor = ColorTheme.black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
