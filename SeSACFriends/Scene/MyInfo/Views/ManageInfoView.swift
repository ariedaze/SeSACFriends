//
//  ManagInfoView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/03.
//

import UIKit
import SnapKit
import Then
import MultiSlider

final class ButtonCollectionViewCell: UICollectionViewCell {
    let button = SeSACButton().then {
        $0.size = .h32
        $0.isUserInteractionEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

final class ManageInfoView: UIView, ViewRepresentable {

    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.isUserInteractionEnabled = true
    }
    let contentView = UIView()
    
    // 1. title 2. 리뷰
    let seSacCardView = SeSACCardView()
    // 3. info
    let myInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 16
        $0.isUserInteractionEnabled = true
    }
    // 3-1 성별
    let genderView = UIView()
    let genderLabel = UILabel().then {
        $0.text = "내 성별"
        $0.font = FontTheme.Title4_R14
        $0.textColor = ColorTheme.black
    }
    let manButton = SeSACButton().then {
        $0.setTitle("남자", for: .normal)
        $0.size = .h48
    }
    let womanButton = SeSACButton().then {
        $0.setTitle("여자", for: .normal)
        $0.size = .h48
    }
    
    // 3-2 취미
    let hobbyView = UIView()
    let hobbyLabel = UILabel().then {
        $0.text = "자주 하는 취미"
        $0.font = FontTheme.Title4_R14
        $0.textColor = ColorTheme.black
    }
    let hobbyTextField = SeSACTextField().then {
        $0.placeholder = "취미를 입력해주세요"
    }
    // 3-3 번호검색
    let numberAccessView = UIView()
    let numberAccessLabel = UILabel().then {
        $0.text = "내 번호 검색 허용"
        $0.font = FontTheme.Title4_R14
        $0.textColor = ColorTheme.black
    }
    let numberAccessSwitch = UISwitch().then {
        $0.onTintColor = ColorTheme.brandgreen
    }
    // 3-4 상대방
    let searchRangeView = UIView()
    let searchRangeLabel = UILabel().then {
        $0.text = "상대방 연령대"
        $0.font = FontTheme.Title4_R14
        $0.textColor = ColorTheme.black
    }
    let ageLabel = UILabel().then {
        $0.text = "18-35"
        $0.font = FontTheme.Title3_M14
        $0.textColor = ColorTheme.brandgreen
    }
    let ageSlider = MultiSlider().then {
        $0.maximumValue = 65
        $0.minimumValue = 17
        $0.tintColor = ColorTheme.brandgreen // color of track
        $0.outerTrackColor = ColorTheme.gray2
        $0.showsThumbImageShadow = false
        
        $0.orientation = .horizontal
        $0.trackWidth = 4
        $0.thumbImage = UIImage(named: "filter_control")
    }
    // 3-3 회원탈퇴
    let withdrawView = UIView()
    let withdrawLabel = UILabel().then {
        $0.text = "회원탈퇴"
        $0.font = FontTheme.Title4_R14
        $0.textColor = ColorTheme.black
    }
    let withdrawButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews() {
        self.backgroundColor = ColorTheme.white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        // 1, 2
        contentView.addSubview(seSacCardView)
        // 3
        contentView.addSubview(myInfoStackView)
        // 3-1 성별
        myInfoStackView.addArrangedSubview(genderView)
        genderView.addSubview(genderLabel)
        genderView.addSubview(manButton)
        genderView.addSubview(womanButton)
        // 3-2 취미
        myInfoStackView.addArrangedSubview(hobbyView)
        hobbyView.addSubview(hobbyLabel)
        hobbyView.addSubview(hobbyTextField)
        // 3-3 번호 검색
        myInfoStackView.addArrangedSubview(numberAccessView)
        numberAccessView.addSubview(numberAccessLabel)
        numberAccessView.addSubview(numberAccessSwitch)
        // 3-4 상대방
        myInfoStackView.addArrangedSubview(searchRangeView)
        searchRangeView.addSubview(searchRangeLabel)
        searchRangeView.addSubview(ageLabel)
        searchRangeView.addSubview(ageSlider)
        // 3-5
        myInfoStackView.addArrangedSubview(withdrawView)
        withdrawView.addSubview(withdrawLabel)
        withdrawView.addSubview(withdrawButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        scrollView.isScrollEnabled = true

        seSacCardView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(16)
            $0.leading.trailing.equalToSuperview()
        }

        // 3-1
        myInfoStackView.snp.makeConstraints {
            $0.top.equalTo(seSacCardView.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(seSacCardView)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-16).priority(250)
        }
        genderLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        manButton.snp.makeConstraints {
            $0.leading.equalTo(genderLabel.snp.trailing)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(56)
        }
        womanButton.snp.makeConstraints {
            $0.leading.equalTo(manButton.snp.trailing).offset(4)
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(56)
        }
        // 3-2
        hobbyLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        hobbyTextField.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(164)
        }
        // 3-3
        numberAccessLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
//            $0.height.equalTo(50)
            $0.centerY.equalToSuperview()
        }
        numberAccessSwitch.snp.makeConstraints {
            $0.leading.equalTo(numberAccessLabel.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }

        // 3-4
        searchRangeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        ageLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.firstBaseline.equalTo(searchRangeLabel.snp.firstBaseline)
        }
        ageSlider.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        // 3-5
        withdrawLabel.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        withdrawButton.snp.makeConstraints {
            $0.edges.equalTo(withdrawLabel)
        }
    }
}

