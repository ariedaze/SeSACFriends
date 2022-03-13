//
//  OnboardingView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/06.
//

import UIKit

struct OnboardingSlide {
    let title: String
    let point: String?
    let image: UIImage?
}


class OnboardingView: UIView, ViewRepresentable {
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let spacing: CGFloat = 0
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier)
        cv.backgroundColor = .white
        return cv
    }()
    
    let button = SeSACButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.status = .fill
    }
    let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.numberOfPages = 3
        $0.backgroundStyle = .minimal
        $0.pageIndicatorTintColor = Colors.gray5.color
        $0.currentPageIndicatorTintColor = Colors.black.color
        $0.isUserInteractionEnabled = false
    }
    
    var slides: [OnboardingSlide] = [
        OnboardingSlide(title: "위치 기반으로 빠르게\n주위 친구를 확인", point: "위치 기반", image: UIImage(named: "onboarding_img1")),
        OnboardingSlide(title: "관심사가 같은 친구를\n찾을 수 있어요", point: "관심사가 같은 친구", image: UIImage(named: "onboarding_img2")),
        OnboardingSlide(title: "SeSAC Friends", point:  nil, image: UIImage(named: "onboarding_img3"))
    ]
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews() {
        backgroundColor = .white
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(button)
    }
    func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.bottom.equalTo(button.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }

        button.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
}

extension OnboardingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier, for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
