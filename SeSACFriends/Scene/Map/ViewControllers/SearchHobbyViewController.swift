//
//  SearchHobbyViewController.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/12.
//

import UIKit

class SearchHobbyViewController: UIViewController {
    let mainView = SearchHobbyView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        self.navigationItem.titleView = mainView.searchBar
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }
}

extension SearchHobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.button.setTitle("안녕?????", for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel().then {
                $0.font = .systemFont(ofSize: 14)
                $0.text = "안녕?????"
                $0.sizeToFit()
            }
            let size = label.frame.size
            
        return CGSize(width: size.width + 16, height: size.height + 10)

    }
}
