//
//  NearSeSACViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import UIKit
import RxSwift
import RxCocoa

enum SearchSeSACType {
    case nearSeSAC
    case receiveSeSAC
}

// 새싹찾기의 주변 새싹 vc
class NearSeSACViewController: UIViewController {
    var type: SearchSeSACType
    let mainView = NearSeSACView()
    let viewModel = SearchFriendsViewModel()
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
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = SearchFriendsViewModel.Input(
            viewDidAppearEvent: self.rx.methodInvoked(#selector(viewDidAppear(_:)))
                .map({ _ in })
                .asObservable()
        )
        
        let output = viewModel.transform(
            input: input,
            disposeBag: disposeBag
        )
        
        switch self.type {
        case .nearSeSAC:
            output.fromQueueDB
                .asDriver(onErrorJustReturn: [])
                .drive(
                    mainView.tableView.rx.items(
                        cellIdentifier: NearSeSACCell.reuseIdentifier,
                        cellType: NearSeSACCell.self)
                ) { (row, element, cell) in
                    cell.sesacCard.profileImageView.profileImageView.image = UIImage(named: "sesac_background_\(element.background+1)")
                    cell.sesacCard.profileImageView.sesacImageView.image = UIImage(named: "sesac_face_\(element.background+1)")
                    cell.sesacCard.nicknameLabel.text = element.nick
                }
                .disposed(by: disposeBag)
        case .receiveSeSAC:
            output.fromQueueDBRequested
                .asDriver(onErrorJustReturn: [])
                .drive(
                    mainView.tableView.rx.items(
                        cellIdentifier: NearSeSACCell.reuseIdentifier,
                        cellType: NearSeSACCell.self)
                ) { (row, element, cell) in
                    cell.sesacCard.nicknameLabel.text = element.nick
                    cell.sesacCard.profileImageView.profileImageView.image = UIImage(named: "sesac_background_\(element.background+1)")
                    cell.sesacCard.profileImageView.sesacImageView.image = UIImage(named: "sesac_face_\(element.background+1)")
                    
                    cell.sesacCard.moreButton.rx.tap
                        .scan(false) { lastState, newState in
                            self.mainView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                            return !lastState
                        }
                        .bind(to: cell.sesacCard.rx.isExpanded)
                        .disposed(by: self.disposeBag)
                }
                .disposed(by: disposeBag)
        }

        output.moveToHome
            .subscribe(onNext: { response in
                if response {
                    UIViewController.changeRootViewControllerToHome()
                }
            })
            .disposed(by: disposeBag)
        
        output.moveToChatRoom
            .subscribe(onNext: { [weak self] response in
                if response {
                    let vc = ChatViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

