//
//  SearchHobbyViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/12.
//

import UIKit
import RxSwift

final class SearchHobbyViewController: UIViewController {
    let mainView = SearchHobbyView()
    let viewModel = SearchHobbyViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureForKeyboard()
        setBackButtonStyle()
        self.navigationItem.titleView = mainView.searchBar
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeKeyboardObserver()
    }
    
    var Recommend: [String] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    var recommendUser: [[String]] = []
    
    func bindViewModel() {
        let output = viewModel.transform(
            input: SearchHobbyViewModel.Input(
                viewDidLoadEvent: Observable.just(()).asObservable(),
                searchHobbyTextFieldDidEditEvent: mainView.searchBar.rx.text.asObservable(),
                searchButtonTapEvent: mainView.button.rx.tap.asObservable()
            ),
            disposeBag: self.disposeBag
        )
        
        output.toastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] message in
                self?.view.makeToast(message, position: .top)
            })
            .disposed(by: disposeBag)
        
        output.onqueueResponse
            .asDriver(onErrorJustReturn: QueueResponse.defaultValue)
            .drive(onNext: { queue in
                self.Recommend = queue.fromRecommend
                self.recommendUser = queue.fromQueueDB.map { $0.hf }
                print("내가 추천 취미다!!!", queue.fromRecommend)
                print("내가 다른 사용자 취미다!!!", queue.fromQueueDB.forEach {$0.hf})
            })
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = SearchSeSACViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// collectionview delegate
extension SearchHobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Recommend.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.button.setTitle(Recommend[indexPath.row], for: .normal)
        return cell
    }

    // section headerView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
 
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HobbyCollectionHeaderView.reuseIdentifier,
                for: indexPath)

            guard let typedHeaderView = headerView as? HobbyCollectionHeaderView
            else { return headerView }

            typedHeaderView.titleLabel.text = indexPath.section == 0 ? "지금 주변에는" : "내가 하고 싶은"
            return typedHeaderView
        default:
            assert(false, "Invalid element type")
        }
    }

    // section size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 56)
    }
}

// keyboard action
extension SearchHobbyViewController {
    @objc override func setKeyboardConstraints(_ show: Bool, keyboardHeight: Double = 0) {
        super.setKeyboardConstraints(show, keyboardHeight: keyboardHeight)
        var keyboardBottomOffsetConstant: Double
        var offsetConstant: Int
        if show {
            offsetConstant = 0
            keyboardBottomOffsetConstant = -(keyboardHeight - self.view.safeAreaInsets.bottom)
            mainView.button.layer.cornerRadius = 0
        } else {
            offsetConstant = 16
            keyboardBottomOffsetConstant = -16
            mainView.button.layer.cornerRadius = 8
        }
        mainView.button.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(offsetConstant)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-offsetConstant)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(keyboardBottomOffsetConstant)
        }
    }

    @objc override func hideKeyboard(_ sender: Any) {
        super.hideKeyboard(sender)
        self.mainView.searchBar.endEditing(true)
    }
}
