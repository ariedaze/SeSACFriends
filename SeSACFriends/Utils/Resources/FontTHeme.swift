//
//  FontTheme.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/01/18.
//

import UIKit

class FontTheme {
    enum Family: String {
        case NotoSansKR
    }
    
    enum FamilyStyle: String {
        case Regular
        case Medium
    }
    
    static var onboardingView: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 24) ?? UIFont.systemFont(ofSize: 24)
    }
    static var onboardingViewP: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Medium.rawValue)", size: 24) ?? UIFont.systemFont(ofSize: 24)
    }
    static var Display1_R20: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 20) ?? UIFont.systemFont(ofSize: 20)
    }
    
    static var Title1_M16: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Medium.rawValue)", size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    static var Title2_R16: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    static var Title3_M14: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Medium.rawValue)", size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    static var Title4_R14: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    static var Title5_M12: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Medium.rawValue)", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    static var Title6_R12: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }

    static var Body1_M16: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Medium.rawValue)", size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    static var Body2_R16: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    static var Body3_R14: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    static var Body4_R12: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    static var cation_R10: UIFont {
        return UIFont(name: "\(Family.NotoSansKR.rawValue)\(FamilyStyle.Regular.rawValue)", size: 10) ?? UIFont.systemFont(ofSize: 10)
    }
}

/*
 Noto Sans KR
 ==> NotoSansKR-Regular
 ==> NotoSansKR-Thin
 ==> NotoSansKR-Light
 ==> NotoSansKR-Medium
 ==> NotoSansKR-Bold
 ==> NotoSansKR-Black
*/
