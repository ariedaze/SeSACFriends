//
//  SeSACBackgroundShopCell.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import UIKit

final class SeSACBackgroundShopCell: UITableViewCell {
    let containerView = UIView()
    
    let sesacImageView = UIImageView().then {
        $0.backgroundColor = .yellow
        $0.layer.cornerRadius = 8
    }
    let sesacInfo = ShopInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(sesacImageView)
        containerView.addSubview(sesacInfo)
        
        containerView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.trailing.bottom.equalToSuperview().offset(-16)
        }
        
        sesacImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(sesacImageView.snp.width)
        }
        sesacInfo.snp.makeConstraints {
            $0.leading.equalTo(sesacImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        sesacInfo.sesacNameLabel.text = "새싹"
        sesacInfo.infoLabel.text = "하늘 공원 매력적"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



