//
//  MyInfoNicknameCell.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/14.
//

import UIKit

final class MyInfoNicknameCell: UITableViewCell, ViewRepresentable {
    let sesacImageView = UIImageView().then {
        $0.image = UIImage(named: "sesac_face_1")
        $0.layer.borderColor = ColorTheme.gray2.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 24
    }
    let nicknameLabel = UILabel().then {
        $0.font = FontTheme.Title1_M16
    }
    let arrow = UIImageView().then {
        $0.image = UIImage(named: "right_arrow")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUpViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setUpViews() {
        contentView.addSubview(sesacImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(arrow)
    }
    func setupConstraints() {
        sesacImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(24)
            $0.bottom.lessThanOrEqualToSuperview().offset(-24)
        }
    
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(sesacImageView.snp.trailing).offset(13)
        }
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
            $0.leading.equalTo(nicknameLabel.snp.trailing)
        }
    }
}
