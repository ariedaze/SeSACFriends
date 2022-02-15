//
//  SeSACProfileShopViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/15.
//

import UIKit

final class SeSACProfileShopViewController: UIViewController {
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let spacing: CGFloat = 12
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
    

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SeSACProfileShopCell.self, forCellWithReuseIdentifier: SeSACProfileShopCell.reuseIdentifier)
        
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension SeSACProfileShopViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeSACProfileShopCell.reuseIdentifier, for: indexPath) as? SeSACProfileShopCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemPink
        cell.infoView.sesacNameLabel.text = "안녕?"
        cell.infoView.infoLabel.text = "내가 이구역의 새싹이다!!"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let spacing: CGFloat = 12 + (16*2)
        return CGSize(width: (width - spacing)/2, height: 300)
    }
}


class SeSACProfileShopCell: UICollectionViewCell {
    let sesacImageView = UIImageView().then {
        $0.backgroundColor = .yellow
        $0.layer.cornerRadius = 8
    }
    
    let infoView = ShopInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(sesacImageView)
        contentView.addSubview(infoView)
        
        sesacImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(sesacImageView.snp.width)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(sesacImageView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
