//
//  SeSACBackgroundShopViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import UIKit

final class SeSACBackgroundShopViewController: UIViewController {
    let tableView = UITableView().then {
        $0.register(SeSACBackgroundShopCell.self, forCellReuseIdentifier: SeSACBackgroundShopCell.reuseIdentifier)
        $0.rowHeight = UITableView.automaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SeSACBackgroundShopViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(ofType: SeSACBackgroundShopCell.self, at: indexPath) else {
            return UITableViewCell()
        }
        return cell
    }
}

