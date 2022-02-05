//
//  AppDelegate.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/18.
//

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        Thread.sleep(forTimeInterval: 5.0)
        // 알림 등록(권한)
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        // 현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
              AppSettings[.FCMToken] = token
            print("FCM registration token: \(token)")
          }
        }

        Auth.auth().currentUser?.getIDToken(completion: { id, error in
            if let error = error {
                print("Error: \(error)")
            } else if let id = id {
                print(id, "내가 id다!!!!")
                AppSettings[.idToken] = id
            }
            
        })
        
        // ui
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = ColorTheme.black
        
        let attributes = [NSAttributedString.Key.font: FontTheme.Title3_M14, .foregroundColor: ColorTheme.black]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
//            [NSAttributedString.Key.foregroundColor : UIColor(red:0.12, green:0.28, blue:0.40, alpha:1.0),
            [NSAttributedString.Key.font: FontTheme.Title3_M14], for: .normal)
        return true
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    // 포그라운드 수신: willPresent(로컬/푸시 동일)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

    }
    
    // 사용자가 로컬/푸시를 클릭했을 때 response 호출 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // SceneDelegate의 Window 객체 가져오기
        // 최상단뷰
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }

    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
