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
    
    private func bind() {
        let input = MapViewModel.Input(
            buttonTap: mainView.myLocationButton.rx.tap.asSignal(),
            myPinLocation: mainView.map.rx.regionDidChangeAnimated
                .skip(1)
                .throttle(.milliseconds(8), latest: true, scheduler: MainScheduler.instance)
                .map { _ in self.mainView.map.centerCoordinate }
        )
        let output = viewModel.transform(input: input)
        
        
        output.requestLocationAuthorization
            .subscribe { status in
                print("status", status)
            }
            .disposed(by: disposeBag)
        
        // 최초로 포커스 시킬 좌표 + 축척
        mainView.map.setRegion(MKCoordinateRegion(center: output.firstLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        
        
        output.sesacList
            .subscribe(onNext: { status in
                print(status.fromQueueDB, "sesac이들")
                status.fromQueueDB.forEach {
                    let coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
                    self.setupMapUI(coordinate, sesac: $0.sesac)
                }
            })
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
}
