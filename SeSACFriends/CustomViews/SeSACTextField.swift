//
//  SeSACTextField.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/20.
//

import UIKit
import SnapKit

class SeSACTextField: UITextField {
    
    private var border = UIView()
    private var label = UILabel()
    
    override var placeholder: String? {
        didSet {
            label.text = placeholder
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [
                NSAttributedString.Key.foregroundColor: ColorTheme.gray7,
                NSAttributedString.Key.font: FontTheme.Title4_R14
            ])
        }
    }
    
    var status: Status = .inactive {
        didSet {
            configuration()
        }
    }
    private let insets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }
    
    // font: TITLE4

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        setUp()
        configuration()
        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    @objc private func handleEditing() {
        self.status = isEmpty ? .inactive : .focus
    }
    
    private func setUp() {
        addSubview(border)
        border.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension SeSACTextField {
    enum Status {
        case inactive
        case focus
        case active
        case disable
        case error
        case success
    }
    
    private func configuration() {
        self.font = FontTheme.Title4_R14
        switch status {
        case .inactive:
            self.textColor = ColorTheme.gray7
            self.border.backgroundColor = ColorTheme.gray3
        case .focus:
            self.textColor = ColorTheme.black
            self.border.backgroundColor = ColorTheme.black
        case .active:
            self.textColor = ColorTheme.black
            self.border.backgroundColor = ColorTheme.gray3
        case .disable:
            self.textColor = ColorTheme.gray7
            self.border.backgroundColor = .clear
        case .error:
            self.textColor = ColorTheme.black
            self.border.backgroundColor = ColorTheme.error
        case .success:
            self.textColor = ColorTheme.black
            self.border.backgroundColor = ColorTheme.success

        }
    }
}
