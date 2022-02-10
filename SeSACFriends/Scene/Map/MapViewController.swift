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
    
    let viewModel = MapViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.reuseID)
        mainView.map.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    private func bind() {
        let input = MapViewModel.Input(
            viewWillAppear: Observable.just(Void()),
            gpsButtonTap: mainView.myLocationButton.rx.tap.asSignal(),
            myPinLocation: mainView.map.rx.regionDidChangeAnimated
                .skip(1)
                .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
                .map { _ in self.mainView.map.centerCoordinate }
        )
        let output = viewModel.transform(input: input)
        
        
        output.requestLocationAuthorization
            .subscribe { status in
                print("status", status)
            }
            .disposed(by: disposeBag)
        
        mainView.map.setRegion(
            MKCoordinateRegion(
                center: output.firstLocation,
                latitudinalMeters: 1400, longitudinalMeters: 1400)
            ,
            animated: true)

        output.sesacList
            .subscribe(onNext: { status in
                print(status.fromQueueDB, "sesac이들")
                status.fromQueueDB.forEach {
                    let coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
                    self.setupMapUI(coordinate, sesac: $0.sesac)
                }
            })
            .disposed(by: disposeBag)
        
        output.matchedState
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
        
        
        
    }
    
    func setupMapUI(_ location: CLLocationCoordinate2D, sesac: Int) {
        let currentPin = SeSACAnnotation(coordinate: location, sesac: sesac)
        mainView.map.addAnnotation(currentPin)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? SeSACAnnotation else {
            return nil
        }
        return setupAnnotationView(for: annotation, on: mapView)
    }
    
    private func setupAnnotationView(for annotation: SeSACAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.reuseID, for: annotation)
        let sesacImage =  UIImage(named: "sesac_face_\(annotation.sesac + 1)")!
        let size = CGSize(width: 80, height: 80)
        UIGraphicsBeginImageContext(size)
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.image = resizedImage
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function)
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
