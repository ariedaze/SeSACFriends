//
//  SeSACNetworkError.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/24.
//

import Foundation

//enum Error
protocol SeSACNetworkError: Error, RawRepresentable {
    static func defaultError() -> Self
}
