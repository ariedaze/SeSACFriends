//
//  ShopViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//

import UIKit
import Tabman
import Pageboy

class ShopViewController: TabmanViewController {
    let sesacTabBarView = SeSACTabBarView()
    var viewControllers: Array<UIViewController> = [AuthCodeViewController()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers.append(AuthEmailViewController())
        self.view.backgroundColor = .white
        addBar(sesacTabBarView.bar, dataSource: self, at: .top)
        self.dataSource = self
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
