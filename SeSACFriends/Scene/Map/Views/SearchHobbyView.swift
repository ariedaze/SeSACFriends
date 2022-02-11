//
//  SearchHobbyView.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/12.
//

import UIKit

class HobbyTagCell: UICollectionViewCell {
    let hobbyButton = SeSACButton().then {
        $0.size = .h32
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(hobbyButton)
        hobbyButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


/// UICollectionViewCell 최대한 왼쪽정렬시켜주는 flowLayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    attributes?.forEach { layoutAttribute in
      if layoutAttribute.representedElementCategory == .cell {
        if layoutAttribute.frame.origin.y >= maxY {
          leftMargin = sectionInset.left
        }
        layoutAttribute.frame.origin.x = leftMargin
        leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
        maxY = max(layoutAttribute.frame.maxY, maxY)
      }
    }
    return attributes
  }
}

class SearchHobbyView: UIView, ViewRepresentable {
    let searchBar = UISearchBar().then {
        $0.placeholder = "띄어쓰기로 복수 입력이 가능해요"
    }
    
    var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let spacing: CGFloat = 8
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier)
//        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let button = SeSACButton().then {
        $0.setTitle("새싹찾기", for: .normal)
        $0.status = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews() {
        addSubview(collectionView)
        addSubview(button)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        button.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
}
