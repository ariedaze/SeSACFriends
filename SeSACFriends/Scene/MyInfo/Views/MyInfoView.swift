//
//  MyInfoView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//

import UIKit

final class MyInfoView: UIView, ViewRepresentable {
    let tableView: UITableView = {
        let table = UITableView()
        table.register(MyInfoNicknameCell.self, forCellReuseIdentifier: MyInfoNicknameCell.reuseIdentifier)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "infoCell")
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews() {
        self.backgroundColor = .white
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
