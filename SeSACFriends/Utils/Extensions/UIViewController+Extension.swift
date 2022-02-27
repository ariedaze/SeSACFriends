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
    
    static func changeRootViewControllerToPhone() {
        let vc = AuthPhoneNumberViewController()
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
    
    static func changeRootViewControllerToHome() {
        let vc = TabBarController()
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            windowScene.windows.first?.rootViewController = vc
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
    
    static func changeRootViewControllerToChat() {
        let vc = ChatViewController()
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            windowScene.windows.first?.rootViewController = vc
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
}

// UINavigationItem
extension UIViewController {
    @objc func setBackButtonStyle() { // navigationitem backbutton image 변경
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(popViewController))
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

// keyboard
extension UIViewController {
    // 백그라운드 터치시 keyboard dismiss
    func addTapGestureForKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    // keyboard 올라왔을 때 애니메이션
    @objc private func keyboardWillAppear(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            setKeyboardConstraints(true, keyboardHeight: keyboardHeight)
            // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
            guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
            }
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    // keyboard 사라질 때 애니메이션
    @objc private func keyboardWillDisappear(notification: NSNotification) {
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        setKeyboardConstraints(false)
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    // keyboard 유무에 따라 constraint 변경
    @objc func setKeyboardConstraints(_ show: Bool, keyboardHeight: Double = 0) {
        
    }
}

// show Alert
extension UIViewController {
    func showAlert(title: String, description: String) {
        let vc = AlertViewController()
        vc.configure(title: title, description: description)
        vc.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func goSetting() {
        let alert = UIAlertController(title: "위치 서비스 사용 불가", message: "현재 위치를 찾기 위해 위치 권한이 필요합니다.", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "설정", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            // 열 수 있는 url 이라면, 이동
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { UIAlertAction in}
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
