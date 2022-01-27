//
//  SeSACTextField.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/20.
//

import UIKit

private enum Constants {
    static let offset: CGFloat = 8
    static let placeholderSize: CGFloat = 14
}

class SeSACTextField: UITextField {
    private var border = UIView()
    private var label = UILabel()
    
    // font: TITLE4
    
    private var labelHeight: CGFloat {
        ceil(font?.withSize(Constants.placeholderSize).lineHeight ?? 0)
    }
    
    private var textInsets: UIEdgeInsets {
        UIEdgeInsets(top: Constants.offset + labelHeight, left: 12, bottom: Constants.offset, right: -12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: textInsets.top)
    }
    
    enum Status {
        case inactive
        case focus
        case active
        case disable
        case error
        case success
    }
}


