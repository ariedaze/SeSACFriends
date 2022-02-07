//
//  CellReusable.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/04.
//

import Foundation
import UIKit

protocol CellReusable {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: CellReusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: CellReusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
