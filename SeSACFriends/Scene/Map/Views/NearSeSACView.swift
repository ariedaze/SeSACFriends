//
//  NearSeSACView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import Foundation
import UIKit

class NearSeSACCell: UITableViewCell {
    let sesacCard = SeSACCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(sesacCard)
        sesacCard.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NearSeSACView: UIView {
    let tableView = UITableView().then {
        $0.register(NearSeSACCell.self, forCellReuseIdentifier: NearSeSACCell.reuseIdentifier)
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

class NearSeSACViewController: UIViewController {
    let mainView = NearSeSACView()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
