//
//  ShopInfoView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import UIKit

final class ShopInfoView: UIView {
    
    let sesacNameLabel = UILabel().then {
        $0.font = FontTheme.Title2_R16
        $0.textColor = Colors.black.color
    }
    
    let priceLabel = SeSACButton().then {
        $0.status = .fill
        $0.size = .h20
    }
    
    let infoLabel = UILabel().then {
        $0.font = FontTheme.Body3_R14
        $0.textColor = Colors.black.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sesacNameLabel)
        addSubview(priceLabel)
        addSubview(infoLabel)
        
        sesacNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(sesacNameLabel)
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(sesacNameLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

