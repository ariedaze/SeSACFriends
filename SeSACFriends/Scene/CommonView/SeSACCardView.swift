//
//  SeSACCardView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import UIKit

// 정보 관리, 새싹 찾기에 들어가는 카드뷰
class SeSACCardView: UIView {
    var isExpanded = true {
        willSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                self.sesacTitleView.isHidden = !newValue
                self.sesacReviewView.isHidden = !newValue
                
            }
            moreButtonImage.image = newValue ? UIImage(named: "close_arrow") : UIImage(named: "more_arrow")
        }
    }
    
    // 1. 프로필이미지
    let profileImageView = SeSACProfileImageView()
    
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
    
    private func setUpViews() {
        // 1.
        self.addSubview(profileImageView)
        // 2
        self.addSubview(seSacInfoStackView)
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
    }
    
    private func setupConstraints() {
        // 1.
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
//            $0.height.equalTo(self.snp.width).multipliedBy(0.5)
        }
        // 2
        seSacInfoStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        // 2-1.
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
    }
}
