//
//  SearchSeSACViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/14.
//

import UIKit
import Tabman
import Pageboy

final class SearchSeSACViewController: TabmanViewController {
    let sesacTabBarView = SeSACTabBarView()
    var viewControllers: Array<UIViewController> = [NearSeSACViewController(type: .nearSeSAC), NearSeSACViewController(type: .receiveSeSAC)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationItem 설정
        self.navigationItem.title = "새싹 찾기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(rightBarButtonClicked))
        setBackButtonStyle()
        
        // tab
        self.view.backgroundColor = .white
        addBar(sesacTabBarView.bar, dataSource: self, at: .top)
        self.dataSource = self

    }
    
    @objc func rightBarButtonClicked() {
        
    }
}


extension SearchSeSACViewController: PageboyViewControllerDataSource, TMBarDataSource {
  
  func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
      switch index {
      case 0:
          return TMBarItem(title: "주변 새싹")
      case 1:
          return TMBarItem(title: "받은 요청")
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
