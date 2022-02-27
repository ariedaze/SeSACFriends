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
import RxCocoa

final class MapViewController: UIViewController {
    let mainView = MapView()
    let viewModel = MapViewModel()
    var disposeBag = DisposeBag()
    
    private var allAnnotations: [MKAnnotation]?
    private var displayedAnnotations: [MKAnnotation]? {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                mainView.map.removeAnnotations(currentAnnotations)
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                mainView.map.addAnnotations(newAnnotations)
            }
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.map.delegate = self
        bindViewModel()
        print(#function, self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.allAnnotations?.removeAll()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bindViewModel() {
        let input = MapViewModel.Input(
            viewDidLoadEvent: Observable.just(()).asObservable(),
            viewDidAppearEvent: self.rx.methodInvoked(#selector(viewDidAppear(_:)))
                .map({ _ in })
                .asObservable(),
            viewDidDisappearEvent:
                self.rx
                .methodInvoked(#selector(viewDidDisappear(_:)))
                .map({_ in})
                .asObservable(),
            mapCenterDidChanged: mainView.map.rx.regionDidChangeAnimated
                .skip(1)
                .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
                .map { [weak self] _ in self?.mainView.map.centerCoordinate ?? CLLocationCoordinate2D(latitude: LocationConstant.sesacCampusCoordinateLatitude, longitude: LocationConstant.sesacCampusCoordinateLongitude) },
            gpsButtonDidTapEvent: mainView.myLocationButton.rx.tap.asObservable(),
            floatingButtonTap: mainView.searchButton.rx.tap
        )
        
        let output = viewModel.transform(
            input: input,
            disposeBag: disposeBag
        )
        
        output.authorizationAlertShouldShow
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] shouldShowAlert in
                if shouldShowAlert { self?.goSetting() }
            })
            .disposed(by: disposeBag)
        
        output.mapCenterLocation
            .asDriver(onErrorJustReturn: self.mainView.map.userLocation.coordinate)
            .drive(onNext: { [weak self] userLocation in
                self?.updateCurrentLocation(
                    latitude: userLocation.latitude,
                    longitude: userLocation.longitude,
                    delta: 0.005
                )
            })
            .disposed(by: disposeBag)
        
        output.sesacList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] list in
                list.forEach {
                    let coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
                    self?.setupMapUI(coordinate, sesac: $0.sesac)
                }
            })
            .disposed(by: disposeBag)
        
        output.matchedState // 매칭 상태
            .map {
                switch $0 {
                case .matched:
                    return UIImage(named: "search_matched")!
                case .matching:
                    return UIImage(named: "search_matching")!
                case .normal:
                    return UIImage(named: "search_default")!
                }
            }
            .bind(to: mainView.searchButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
//        
        mainView.searchButton.rx.tap
            .subscribe { [weak self] _ in
                let vc =  SearchHobbyViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension MapViewController: MKMapViewDelegate {
    private func updateCurrentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta: Double) {
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        mainView.map.setRegion(locationRegion, animated: true)
    }
    
    func configureCenter() { // 현재위치를 중앙으로
        mainView.map.userTrackingMode = .follow
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let locationRegion = MKCoordinateRegion(center: mainView.map.userLocation.coordinate, span: span)
        mainView.map.setRegion(locationRegion, animated: true)
    }
    
    private func setupMapUI(_ location: CLLocationCoordinate2D, sesac: Int) { // 새싹핀
        let currentPin = SeSACAnnotation(coordinate: location, sesac: sesac)
        mainView.map.addAnnotation(currentPin)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? SeSACAnnotation else {
            return nil
        }
        return setupAnnotationView(for: annotation, on: mapView)
    }
    
    private func setupAnnotationView(for annotation: SeSACAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.reuseIdentifier, for: annotation)
        let sesacImage =  UIImage(named: "sesac_face_\(annotation.sesac + 1)")!
        let size = CGSize(width: 80, height: 80)
        UIGraphicsBeginImageContext(size)
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.image = resizedImage
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print(#function)
        var span = mapView.region.span
        // lat: 위도 long: 경도
        // 위도 1도에 111Km (가로선) 경도 1도에 88.8km (세로선)
        // min 반지름 50m, max 반지름 3km
        let minDelta = 0.1 / 88.8
        let maxDelta = 6 / 88.8
        if span.latitudeDelta < minDelta { // MIN LEVEL
            span = MKCoordinateSpan(latitudeDelta: minDelta, longitudeDelta: minDelta)
        } else if span.latitudeDelta > maxDelta { // MAX LEVEL
            span = MKCoordinateSpan(latitudeDelta: maxDelta, longitudeDelta: maxDelta)
        }
        mapView.region.span = span
    }
}
