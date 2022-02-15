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
    
    func bindViewModel() {
        mainView.button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = NearUserViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// collectionview delegate
extension SearchHobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.button.setTitle("안녕?????", for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel().then {
            $0.font = FontTheme.Title4_R14
            $0.text = "안녕?????"
            $0.sizeToFit()
        } // button의 가로 길이를 구하기 위함
        let size = label.frame.size
        return CGSize(width: size.width + 32, height: 32)
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
