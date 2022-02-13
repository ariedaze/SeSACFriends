//
//  HobbyTagCell.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/14.
//

import UIKit

final class HobbyTagCell: UICollectionViewCell {
    let hobbyButton = SeSACButton().then {
        $0.size = .h32
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(hobbyButton)
        hobbyButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

