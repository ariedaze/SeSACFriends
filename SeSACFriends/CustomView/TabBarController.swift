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
        self.tabBar.tintColor = ColorTheme.green
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = nil
            appearance.shadowImage = nil
            appearance.backgroundColor = .white
            appearance.selectionIndicatorTintColor = ColorTheme.green
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UITabBar.appearance().barTintColor = ColorTheme.white
            UITabBar.appearance().shadowImage = nil
            UITabBar.appearance().backgroundImage = nil
        }
        
        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), tag: 0)

        let shopVC = ShopViewController()
        shopVC.tabBarItem = UITabBarItem(title: "새싹샵", image: UIImage(named: "shop"), tag: 1)
        
        let chatVC = ChatViewController()
        chatVC.tabBarItem = UITabBarItem(title: "새싹친구", image: UIImage(named: "friends"), tag: 2)

        let myInfoVC = MyInfoViewController()
        myInfoVC.tabBarItem = UITabBarItem(title: "내정보", image: UIImage(named: "myinfo"), tag: 2)
        
        let mapNavigationVC = UINavigationController(rootViewController: mapVC)
        let shopNavigationVC = UINavigationController(rootViewController: shopVC)
        let chatNavigationVC = UINavigationController(rootViewController: chatVC)
        let myInfoNavigationVC = UINavigationController(rootViewController: myInfoVC)
        setViewControllers([mapNavigationVC, shopNavigationVC, chatNavigationVC, myInfoNavigationVC], animated: false)
    }
}



