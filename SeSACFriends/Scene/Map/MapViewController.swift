//
//  MapViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/26.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift

class MapViewController: UIViewController {
    let mainView = MapView()
    let locationManager = LocationManager.shared // 위치 조종 매니저
    var disposeBag = DisposeBag()
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) //새싹 영등포 캠퍼스의 위치입니다. 여기서 시작하면 재밌을 것 같죠? 하하
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let center = mainView.map.centerCoordinate
        
        locationManager.locationSubject // 실시간 위치 구독
            .compactMap { $0 }
            .subscribe(onNext: {
                print("업데이트", $0)
            })
            .disposed(by: self.disposeBag)
        
        locationManager.requestLocation() // 위치 권한
            .bind { print($0) }
            .disposed(by: self.disposeBag)
        
        mainView.map.delegate = self
        // 최초로 포커스 시킬 좌표 + 축척
        mainView.map.setRegion(MKCoordinateRegion(center: sesacCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)

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
            print("not determined")
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
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
//            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
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
    
    
    @objc func findMyLocation() {
        mainView.map.showsUserLocation = true
        mainView.map.setUserTrackingMode(.follow, animated: true)
    }
}
