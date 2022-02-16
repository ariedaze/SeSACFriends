//
//  ShopViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//

import UIKit
import Tabman
import Pageboy

final class ShopViewController: TabmanViewController {
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.isUserInteractionEnabled = true
    }
    let contentView = UIView()
    let imageView = SeSACProfileImageView()
    let tabView = UIView()
    
    let sesacTabBarView = SeSACTabBarView()
    
    var viewControllers = [
        SeSACProfileShopViewController(), SeSACBackgroundShopViewController()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.calculateRequiredInsets(), "이거")
        
        tabView.addSubview(imageView)
        view.addSubview(tabView)
        
        tabView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        
        tabView.backgroundColor = .magenta
        
        self.view.backgroundColor = .white
        
        addBar(sesacTabBarView.bar, dataSource: self, at: .custom(view: tabView, layout: { bar in
            bar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bar.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
                bar.centerXAnchor.constraint(equalTo: self.tabView.centerXAnchor),
                bar.leadingAnchor.constraint(equalTo: self.tabView.leadingAnchor),
                bar.trailingAnchor.constraint(equalTo: self.tabView.trailingAnchor)
            ])
        }))
        
        self.dataSource = self
    }
    
    override func calculateRequiredInsets() -> TabmanViewController.Insets {
        return Insets(barInsets: UIEdgeInsets(top: 270, left: 0, bottom: 0, right: 0), safeAreaInsets: UIEdgeInsets(top: 270, left: 0, bottom: 0, right: 0))
    }
}

extension ShopViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "새싹")
        case 1:
            return TMBarItem(title: "배경")
        default:
            return TMBarItem(title: "Page \(index)")
        }
        
    }
    
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
