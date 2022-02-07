//
//  MapViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    let mainView = MapView()
    let locationManager = CLLocationManager() // 위치 조종 매니저
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization() // 권한 설정
        mainView.map.delegate = self
        locationManager.delegate = self
        mainView.myLocationButton.addTarget(self, action: #selector(findMyLocation), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}


extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    //권한 설정을 위한 코드들
    
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted:
            print("restricted")
            goSetting()
        case .denied:
            print("denided")
            goSetting()
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("wheninuse")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    func goSetting() {
        let alert = UIAlertController(title: "위치 서비스 사용 불가", message: "설정으로 이동하기", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "확인", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            // 열 수 있는 url 이라면, 이동
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { UIAlertAction in }
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationServicesAuthorization()
    }

    @objc func findMyLocation() {
        guard let currentLocation = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        mainView.map.showsUserLocation = true
        mainView.map.setUserTrackingMode(.follow, animated: true)
    }
}
