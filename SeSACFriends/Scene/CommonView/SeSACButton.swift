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
    
    override var intrinsicContentSize: CGSize {
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
            self.backgroundColor = .clear
            self.setTitleColor(Colors.black.color, for: .normal)
            self.layer.borderWidth = 1
            self.layer.borderColor = Colors.gray4.color.cgColor
        case .fill:
            self.backgroundColor = Colors.brandgreen.color
            self.setTitleColor(Colors.white.color, for: .normal)
            self.layer.borderWidth = 0
        case .outline:
            self.backgroundColor = .clear
            self.setTitleColor(Colors.brandgreen.color, for: .normal)
            self.layer.borderWidth = 1
            self.layer.borderColor = Colors.brandgreen.color.cgColor
        case .cancel:
            self.backgroundColor = Colors.gray2.color
            self.setTitleColor(Colors.black.color, for: .normal)
            self.layer.borderWidth = 0
        case .disable:
            self.backgroundColor = Colors.gray6.color
            self.setTitleColor(Colors.gray3.color, for: .normal)
            self.layer.borderWidth = 0
        case .normal:
            self.backgroundColor = Colors.white.color
            self.setTitleColor(Colors.black.color, for: .normal)
            self.layer.borderWidth = 0
        case .error:
            self.backgroundColor = Colors.error.color
            self.setTitleColor(Colors.white.color, for: .normal)
            self.layer.borderWidth = 0
        case .success:
            self.backgroundColor = Colors.success.color
            self.setTitleColor(Colors.white.color, for: .normal)
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
        case error
        case success
    }
    
    enum Size: Int {
        case h48 = 48
        case h40 = 40
        case h32 = 32
        case h20 = 20
    }
}
