//
//  UIViewController+Extension.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/24.
//

import UIKit

// 최상단 뷰컨트롤러를 판단해주는 UIViewController Extension
extension UIViewController {
    var topViewController: UIViewController {
        return topViewController(currentViewController: self)
    }
    
    // currentViewController: TabBarController
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currentViewController: selectedViewController)
        } else if let navigationController = currentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currentViewController: visibleViewController)
        } else if let presentedViewController = currentViewController.presentedViewController {
            return self.topViewController(currentViewController: presentedViewController)
        } else {
            return currentViewController
        }
    }
    
    func changeRootViewControllerToPhone() {
        let vc = AuthPhoneNumberViewController()
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
    
    func changeRootViewControllerToHome() {
        let vc = TabBarController()
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }

}

// UINavigationItem
extension UIViewController {
    @objc func setBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(popViewController))
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
