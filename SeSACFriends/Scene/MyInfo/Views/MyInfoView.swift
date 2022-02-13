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
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
