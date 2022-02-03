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
        
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
    }
    
    private func bind() {
        let input = AuthGenderViewModel.Input(
            buttonTrigger: mainView.button.rx.tap,
            manButtonTap: mainView.manButton.rx.tap.asSignal(),
            womanButtonTap: mainView.womanButton.rx.tap.asSignal())
        
        let output = viewModel.transform(input: input)
        
        output.out
            .subscribe (onNext: { _ in
                print("성공?")
            })
            .disposed(by: disposeBag)
        
        output.buttonTap
            .subscribe (onNext: { value in
                print(value)
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
        
        
    }
    
    
    @objc func buttonClicked() {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .purple
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension Reactive where Base: UIButton {
    public var isSelectedChanged: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents:  [.allEditingEvents,.touchUpInside],
            getter: { $0.isSelected },
            setter: { $0.isSelected = $1 })
    }

}
