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
    let viewModel = MapViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 최초로 포커스 시킬 좌표 + 축척
//        mainView.map.setRegion(MKCoordinateRegion(center: sesacCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bind() {
        let input = MapViewModel.Input(
            buttonTap: mainView.myLocationButton.rx.tap.asSignal(),
            myPinLocation: mainView.map.rx.regionDidChangeAnimated
                .skip(1)
                .map { _ in self.mainView.map.centerCoordinate }
        )
        let output = viewModel.transform(input: input)
        
        output.firstRequest
            .subscribe { status in
                print("status", status)
            }
            .disposed(by: disposeBag)

    }
    
    func setupMapUI(_ location: CLLocationCoordinate2D) {
        let currentPin = SeSACAnnotation(coordinate: location)
        mainView.map.addAnnotation(currentPin)
    }
}
