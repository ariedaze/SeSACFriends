//
//  MapViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//

import UIKit
import Moya

class MapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print(AppSettings[.idToken], "idtoken")
//        var state = .loading
//        let provider = MoyaProvider<AuthAPI>()
//        // 2
//        provider.request(.signup) { result in
//            dump(result, name: "result")
//          // 3
//          switch result {
//          case .success(let response):
//            do {
//              // 4
//              print(try response.mapJSON())
//            } catch {
////              self.state = .error
//            }
//          case .failure:
//            // 5
//              print("fail")
////            self.state = .error
//          }
//        }
        
    }
}
