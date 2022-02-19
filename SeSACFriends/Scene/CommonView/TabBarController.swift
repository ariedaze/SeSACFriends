//
//  TabBarController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureTabBarItems()
    }

    
    private func configureTabBarItems() {
        self.tabBar.tintColor = ColorTheme.brandgreen
        self.tabBar.unselectedItemTintColor = ColorTheme.gray6
        self.tabBar.isTranslucent = false
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .white
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: ColorTheme.brandgreen]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: ColorTheme.gray6]
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        } else {

            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: ColorTheme.brandgreen], for: .selected)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: ColorTheme.gray6], for: .normal)
            tabBar.barTintColor = .white
        }
        
        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_selected"))
    
        let shopVC = ShopParentViewController()
        shopVC.tabBarItem = UITabBarItem(title: "새싹샵", image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop_selected"))

        let myInfoVC = MyInfoViewController()
        myInfoVC.tabBarItem = UITabBarItem(title: "내정보", image: UIImage(named: "myinfo"), tag: 3)
        
        let mapNavigationVC = UINavigationController(rootViewController: mapVC)
        let shopNavigationVC = UINavigationController(rootViewController: shopVC)
        let myInfoNavigationVC = UINavigationController(rootViewController: myInfoVC)
        setViewControllers([mapNavigationVC, shopNavigationVC, myInfoNavigationVC], animated: false)
    }
}



