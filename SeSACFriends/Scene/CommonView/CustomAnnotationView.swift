//
//  CustomAnnotationView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/08.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
    
}


class SeSACAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var sesac: Int
    
    init(coordinate: CLLocationCoordinate2D, sesac: Int) {
        self.coordinate = coordinate
        self.sesac = sesac
    }
}
