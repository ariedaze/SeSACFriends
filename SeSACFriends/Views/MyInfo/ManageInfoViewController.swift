//
//  ManageInfoViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/03.
//

import UIKit
import RxSwift
import RxCocoa

class ManageInfoViewController: UIViewController {
    let mainView = ManageInfoView()
    var viewModel = ManageInfoViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "정보 관리"
        setBackButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightBarButtonClicked))
        
        mainView.titleCollectionView.delegate = self
        mainView.titleCollectionView.dataSource = self
        viewDidLayoutSubviews()
        bind()
        
        mainView.ageSlider.value = [17, 55]
    }
    
    private func bind() {
        let input = ManageInfoViewModel.Input(
            buttonTrigger: mainView.withdrawButton.rx.tap
            )
        
        let output = viewModel.transform(input: input)
    
        output.out
            .subscribe (onNext: { _ in
                print("성공?")
            })
            .disposed(by: disposeBag)
        
        mainView.moreButton.rx.tap
            .scan(false) { lastState, newState in
                return !lastState
            }
            .bind(to: self.mainView.rx.isExpanded)
            .disposed(by: disposeBag)
    }
    
    @objc func rightBarButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension ManageInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.button.setTitle("안녕", for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let spacing: CGFloat = 16 * 4 + 8
        return CGSize(width: (width - spacing)/2, height: 32)
    }
}
