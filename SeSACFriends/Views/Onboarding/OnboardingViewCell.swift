//
//  OnboardingViewCell.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/06.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    let labelView = UIView()
    let label = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = FontTheme.onboardingView
        $0.textColor = ColorTheme.black
    }
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(labelView)
        labelView.addSubview(label)
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        labelView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(imageView.snp.top)
        }
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(_ slide: OnboardingSlide) {
        imageView.image = slide.image
        label.text = slide.title
        
        if let point = slide.point {
            guard let text = label.text else {
                return
            }
            let font = FontTheme.onboardingViewP
            //label에 있는 Text를 NSMutableAttributedString으로 만들어준다.
            let attributedString = NSMutableAttributedString(string: text)
            
            attributedString.addAttribute(.foregroundColor, value: ColorTheme.brandgreen, range: (text as NSString).range(of:point))
            attributedString.addAttribute(.font, value: font, range: (text as NSString).range(of: point))
            
            //최종적으로 내 label에 속성을 적용
            label.attributedText = attributedString
        }
        

    }
}
