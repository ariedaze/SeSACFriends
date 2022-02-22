//
//  NearSeSACViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import UIKit
import RxSwift

enum SearchSeSACType {
    case nearSeSAC
    case receiveSeSAC
}

// 새싹찾기의 주변 새싹 vc
class NearSeSACViewController: UIViewController {
    var type: SearchSeSACType
    let mainView = NearSeSACView()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    convenience init() {
        self.init(type: .nearSeSAC)
    }

    init(type: SearchSeSACType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        bindViewModel()
    }
    
    private func bindViewModel() {
        
    }
}

extension NearSeSACViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(ofType: NearSeSACCell.self, at: indexPath) else {
            return UITableViewCell()
        }
        cell.sesacCard.moreButton.rx.tap
            .scan(false) { lastState, newState in
                tableView.reloadRows(at: [indexPath], with: .none)
                return !lastState
            }
            .bind(to: cell.sesacCard.rx.isExpanded)
            .disposed(by: self.disposeBag)
        
        return cell
    }
}
