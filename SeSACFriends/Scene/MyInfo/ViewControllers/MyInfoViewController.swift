//
//  MyInfoViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//

import UIKit
import RxSwift

enum MyInfo: String, CaseIterable {
    case notice = "공지사항"
    case faq = "자주 묻는 질문"
    case qna = "1:1 문의"
    case alarm = "알림 설정"
    case permit = "이용 약관"
    
    var imageName: String {
        switch self {
        case .notice:
            return "notice"
        case .faq:
            return "faq"
        case .qna:
            return "qna"
        case .alarm:
            return "setting_alarm"
        case .permit:
            return "permit"
        }
    }
}

final class MyInfoViewController: UIViewController {
    let mainView = MyInfoView()
    let viewModel = MyInfoViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "내정보"
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoNicknameCell.reuseIdentifier, for: indexPath) as? MyInfoNicknameCell else {
                return UITableViewCell()
            }
            let output = viewModel.transform(
                input: MyInfoViewModel.Input(viewDidLoadEvent: Observable.just(()).asObservable()),
                disposeBag: disposeBag)
                
            output.myinfo
                .subscribe(onNext: { nick in
                    cell.nicknameLabel.text = nick
                })
                .disposed(by: disposeBag)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            let category = MyInfo.allCases[indexPath.row]
            content.image = UIImage(named: "\(category.imageName)")
            content.imageProperties.tintColor = Colors.black.color
            content.imageToTextPadding = 14
            content.attributedText = NSAttributedString(string: "\(category.rawValue)", attributes: [ .font: FontTheme.Title2_R16, .foregroundColor: Colors.black.color])
            cell.contentConfiguration = content
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : MyInfo.allCases.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = ManageInfoViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 74
    }
}
