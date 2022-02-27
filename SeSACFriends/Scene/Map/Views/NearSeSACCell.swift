//
//  NearSeSACCell.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import UIKit

class NearSeSACCell: UITableViewCell {
    let sesacCard = SeSACCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(sesacCard)
        sesacCard.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        sesacCard.isExpanded = true
        sesacCard.titleCollectionView.dataSource = self
        sesacCard.titleCollectionView.delegate = self
        sesacCard.profileImageView.button.status = .error
        sesacCard.profileImageView.button.setTitle("요청하기", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension NearSeSACCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.button.setTitle("안녕", for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let spacing: CGFloat = 16 * 4 + 8
        return CGSize(width: (width - spacing)/2, height: 32)
    }
}
