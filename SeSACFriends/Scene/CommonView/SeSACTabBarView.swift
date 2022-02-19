//
//  NearUserView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/14.
//

import UIKit
import Tabman


final class SeSACTabBarView: UIView {
    let bar = TMBar.ButtonBar().then {
        $0.layout.transitionStyle = .snap
        $0.layout.contentMode = .fit
        $0.backgroundView.style = TMBarBackgroundView.Style.flat(color: .white)
        
        // 인디케이터
        $0.indicator.weight = .custom(value: 2)
        $0.indicator.tintColor = ColorTheme.brandgreen
        
        // tintColor + font size
        $0.buttons.customize { (button) in
            button.tintColor = ColorTheme.gray6
            button.selectedTintColor = ColorTheme.brandgreen
            button.font = FontTheme.Title4_R14
            button.selectedFont = FontTheme.Title3_M14
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        settingTabBar(ctBar: bar)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
