//
//  ButtonCollectionViewCell.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/18.
//

import UIKit

final class ButtonCollectionViewCell: UICollectionViewCell {
    let button = SeSACButton().then {
        $0.size = .h32
        $0.isUserInteractionEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // cell size
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)

        var frame = layoutAttributes.frame
        frame.size.width = ceil(size.width) + 32
        frame.size.height = 32
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
