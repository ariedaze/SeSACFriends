//
//  NearSeSACView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import Foundation
import UIKit
import RxSwift

class NearSeSACView: UIView {
    let tableView = UITableView().then {
        $0.register(NearSeSACCell.self, forCellReuseIdentifier: NearSeSACCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
