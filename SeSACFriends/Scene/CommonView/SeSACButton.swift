//
//  SeSACButton.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/18.
//

import UIKit

class SeSACButton: UIButton {
    var status: Status = .inactive {
        didSet {
            configuration()
        }
    }
    
    var size: Size = .h48
    
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = CGFloat(self.size.rawValue)
        return size
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration()
        self.layer.cornerRadius = 8
        self.titleLabel?.font = FontTheme.Body3_R14
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension SeSACButton {
    private func configuration() {
        switch status {
        case .inactive:
            self.backgroundColor = ColorTheme.clear
            self.setTitleColor(ColorTheme.black, for: .normal)
            self.layer.borderWidth = 1
            self.layer.borderColor = ColorTheme.gray4.cgColor
        case .fill:
            self.backgroundColor = ColorTheme.brandgreen
            self.setTitleColor(ColorTheme.white, for: .normal)
            self.layer.borderWidth = 0
        case .outline:
            self.backgroundColor = ColorTheme.clear
            self.setTitleColor(ColorTheme.brandgreen, for: .normal)
            self.layer.borderWidth = 1
            self.layer.borderColor = ColorTheme.brandgreen.cgColor
        case .cancel:
            self.backgroundColor = ColorTheme.gray2
            self.setTitleColor(ColorTheme.black, for: .normal)
            self.layer.borderWidth = 0
        case .disable:
            self.backgroundColor = ColorTheme.gray6
            self.setTitleColor(ColorTheme.gray3, for: .normal)
            self.layer.borderWidth = 0
        case .normal:
            self.backgroundColor = ColorTheme.white
            self.setTitleColor(ColorTheme.black, for: .normal)
            self.layer.borderWidth = 0
        }
    }
    
    enum Status {
        case inactive
        case fill
        case outline
        case cancel
        case disable
        case normal
    }
    
    enum Size: Int {
        case h48 = 48
        case h40 = 40
        case h32 = 32
        case h20 = 20
    }
}
