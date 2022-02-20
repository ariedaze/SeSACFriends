//
//  MapView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/07.
//

import UIKit
import MapKit
import SnapKit
import Then

final class MapView: UIView, ViewRepresentable {
    let map = MKMapView().then {
        $0.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.reuseIdentifier)
        $0.showsUserLocation = true
        $0.userTrackingMode = .follow
    }
    
    let myPin = UIImageView().then {
        $0.image = UIImage(named: "map_marker")
    }
    
    let buttonStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
    }
    
    let totalButton = UIButton().then {
        $0.backgroundColor = ColorTheme.brandgreen
        $0.setTitleColor(ColorTheme.white, for: .normal)
        $0.setTitle("전체", for: .normal)
        $0.titleLabel?.font = FontTheme.Body3_R14
    }
    let manButton = UIButton().then {
        $0.backgroundColor = ColorTheme.white
        $0.setTitleColor(ColorTheme.black, for: .normal)
        $0.setTitle("남자", for: .normal)
        $0.titleLabel?.font = FontTheme.Body3_R14
    }
    let womanButton = UIButton().then {
        $0.backgroundColor = ColorTheme.white
        $0.setTitleColor(ColorTheme.black, for: .normal)
        $0.setTitle("여자", for: .normal)
        $0.titleLabel?.font = FontTheme.Body3_R14
    }
    
    let myLocationButton = UIButton().then {
        $0.backgroundColor = ColorTheme.white
        $0.setImage(UIImage(named: "place"), for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = ColorTheme.gray3.cgColor
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize.zero
        $0.layer.shadowRadius = 2
    }
    
    let searchButton = UIButton().then {
        $0.setImage(UIImage(named: "search_matching"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews() {
        addSubview(map)
        addSubview(buttonStack)
        buttonStack.addArrangedSubview(totalButton)
        buttonStack.addArrangedSubview(manButton)
        buttonStack.addArrangedSubview(womanButton)
        addSubview(myLocationButton)
        addSubview(searchButton)
        addSubview(myPin)
    }
    
    func setupConstraints() {
        map.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        myPin.snp.makeConstraints {
            $0.center.equalTo(map)
            $0.width.height.equalTo(48)
        }
        buttonStack.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        manButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        myLocationButton.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(48)
        }
        searchButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.width.height.equalTo(64)
        }
    }

}
