//
//  MKMapView+Rx.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/09.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {

    public weak private(set) var mapView: MKMapView?

    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMKMapViewDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxMKMapViewDelegateProxy(mapView: $0) }
    }
}

extension Reactive where Base: MKMapView {
    public var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: base)
    }
    
    public var regionDidChangeAnimated: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { parameters in
                return (parameters[1] as? Bool) ?? false
            }
        return ControlEvent(events: source)
    }
}
