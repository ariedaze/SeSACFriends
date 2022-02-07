//
//  AuthGenderViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/21.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthGenderViewController: UIViewController {
    let mainView = AuthGenderView()
    let viewModel = AuthGenderViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.configure(
            titleText: "성별을 선택해 주세요",
            descriptionText: "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        )
        
        bind()
    }
    
    private func bind() {
        let input = AuthGenderViewModel.Input(
            buttonTrigger: mainView.button.rx.tap.asSignal(),
            manButtonTap: mainView.manButton.rx.tap.asSignal(),
            womanButtonTap: mainView.womanButton.rx.tap.asSignal())
        
        let output = viewModel.transform(input: input)
        
        
        output.buttonTap
            .subscribe (onNext: { value in
                self.mainView.button.status = .fill
                if value == 0 {
                    if self.mainView.manButton.isSelected {
                        self.mainView.manButton.isSelected.toggle()
                    }
                    self.mainView.womanButton.isSelected.toggle()
                    self.mainView.background(self.mainView.womanButtonView, selected: self.mainView.womanButton.isSelected)
                    self.mainView.background(self.mainView.manButtonView, selected: false)
                } else {
                    if self.mainView.womanButton.isSelected {
                        self.mainView.womanButton.isSelected.toggle()
                    }
                    self.mainView.manButton.isSelected.toggle()
                    self.mainView.background(self.mainView.womanButtonView, selected: false)
                    self.mainView.background(self.mainView.manButtonView, selected: self.mainView.manButton.isSelected)
                }
            })
            .disposed(by: disposeBag)
        
        output.success
            .drive(onNext: { [weak self] _ in
                self?.changeRootViewControllerToHome()
            })
            .disposed(by: disposeBag)
    }
}
