//
//  Reusable.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/27.
//

import UIKit
import MapKit

protocol Reusable {
    static var reuseIdentifier: String {get}
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
extension UIViewController: Reusable {}

extension UITableView {
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T? where T: UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier,
                                             for: indexPath) as? T
        return cell
    }
}

extension SeSACAnnotation: Reusable {}
extension CustomAnnotationView: Reusable {}
