//
//  ManagInfoView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/03.
//

import UIKit
import SnapKit
import Then

class ButtonCollectionViewCell: UICollectionViewCell {
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

class ManageInfoView: UIView, ViewRepresentable {
    var isExpanded = false {
        willSet {
            if newValue {
                sesacTitleView.isHidden = false
                sesacReviewView.isHidden = false
                moreButtonImage.image = UIImage(named: "close_arrow")
            } else {
                sesacTitleView.isHidden = true
                sesacReviewView.isHidden = true
                moreButtonImage.image = UIImage(named: "more_arrow")
            }
        }
    }
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.isUserInteractionEnabled = true
    }
    let contentView = UIView()
    
    // 1. 프로필이미지
    let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .yellow
    }
    
    // 2. 새싹 타이틀 / 리뷰 스택뷰
    let seSacInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ColorTheme.gray2.cgColor
        $0.alignment = .fill
        $0.distribution = .fill
        $0.isUserInteractionEnabled = true
    }
    // 2-1
    let nicknameView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    let nicknameLabel = UILabel().then {
        $0.text = "김새싹"
        $0.font = FontTheme.Title1_M16
        $0.textColor = ColorTheme.black
    }
    let moreButtonImage = UIImageView().then {
        $0.image = UIImage(named: "more_arrow")
    }
    let moreButton = UIButton()
    
    // 2-2 새싹타이틀
    let sesacTitleView = UIView()
    let sesacTitleLabel = UILabel().then {
        $0.text = "새싹 타이틀"
        $0.font = FontTheme.Title6_R12
        $0.textColor = ColorTheme.black
    }
    
    var titleCollectionView: DynamicHeightCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let spacing: CGFloat = 8
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        let cv = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier)
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    // 2-3 새싹 리뷰
    let sesacReviewView = UIView()
    let sesacReviewLabel = UILabel().then {
        $0.text = "새싹 리뷰"
        $0.font = FontTheme.Title6_R12
        $0.textColor = ColorTheme.black
    }
    
    // 3. info
    let myInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
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
    // 3-4 상대방
    let searchRangeView = UIView()
    let searchRangeLabel = UILabel().then {
        $0.text = "상대방 연령대"
        $0.font = FontTheme.Title4_R14
        $0.textColor = ColorTheme.black
    }
    // 3-3 회원탈퇴
    let withdrawLabel = UILabel().then {
        $0.text = "회원탈퇴"
        $0.font = FontTheme.Title4_R14
        $0.textColor = ColorTheme.black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
        titleCollectionView.reloadData()
        titleCollectionView.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews() {
        self.backgroundColor = ColorTheme.white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        // 1.
        contentView.addSubview(profileImageView)
        // 2
        contentView.addSubview(seSacInfoStackView)
        // 2-1
        seSacInfoStackView.addArrangedSubview(nicknameView)
        nicknameView.addSubview(nicknameLabel)
        nicknameView.addSubview(moreButtonImage)
        nicknameView.addSubview(moreButton)
        // 2-2
        sesacTitleView.isHidden = true
        sesacTitleView.addSubview(sesacTitleLabel)
        sesacTitleView.addSubview(titleCollectionView)
        seSacInfoStackView.addArrangedSubview(sesacTitleView)
        // 2-3
        seSacInfoStackView.addArrangedSubview(sesacReviewView)
        sesacReviewView.isHidden = true
        sesacReviewView.addSubview(sesacReviewLabel)
        // 3
        contentView.addSubview(myInfoStackView)
        // 3-1
        myInfoStackView.addArrangedSubview(genderView)
        genderView.addSubview(genderLabel)
        genderView.addSubview(manButton)
        genderView.addSubview(womanButton)
        // 3-2
        myInfoStackView.addArrangedSubview(hobbyView)
        hobbyView.addSubview(hobbyLabel)
        hobbyView.addSubview(hobbyTextField)
        // 3-3
        myInfoStackView.addArrangedSubview(numberAccessView)
        numberAccessView.addSubview(numberAccessLabel)
        // 3-4
        myInfoStackView.addArrangedSubview(searchRangeView)
        searchRangeView.addSubview(searchRangeLabel)
        // 3-5
        myInfoStackView.addArrangedSubview(withdrawLabel)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
        }
        
        contentView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        scrollView.isScrollEnabled = true

        // 1.
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(self.snp.width).multipliedBy(0.5)
        }
        // 2-1.
        seSacInfoStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        moreButtonImage.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        moreButton.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.leading.equalTo(moreButtonImage.snp.leading).offset(-8)
        }
        // 2-2
        sesacTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        titleCollectionView.snp.makeConstraints {
            $0.top.equalTo(sesacTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(sesacTitleLabel)
            $0.bottom.equalToSuperview().offset(-16)
        }
        // 2-3
        sesacReviewLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        // 3-1
        myInfoStackView.snp.makeConstraints {
            $0.top.equalTo(seSacInfoStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(seSacInfoStackView)
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
            $0.top.bottom.leading.equalToSuperview()
            $0.height.equalTo(50)
        }
        scrollView.backgroundColor = .green
        contentView.backgroundColor = .cyan
        hobbyView.backgroundColor = .brown
        myInfoStackView.backgroundColor = .orange
        numberAccessView.backgroundColor = .red
        searchRangeView.backgroundColor = .purple
        withdrawLabel.backgroundColor = .blue
        // 3-4
        searchRangeLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.height.equalTo(50)
        }
        // 3-5
        withdrawLabel.snp.makeConstraints {
            $0.height.equalTo(48)
        }

    }
}

