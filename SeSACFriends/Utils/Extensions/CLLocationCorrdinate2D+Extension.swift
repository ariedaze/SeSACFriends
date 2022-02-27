//
//  CLLocationCorrdinate2D+Extension.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/28.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude.cutNumber == rhs.latitude.cutNumber && lhs.longitude.cutNumber == rhs.longitude.cutNumber
}
