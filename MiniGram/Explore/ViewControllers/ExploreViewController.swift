//
//  ExploreViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let collectionViewXInset: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: collectionViewXInset, bottom: 0, right: collectionViewXInset)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets = collectionViewXInset * 2
        return CGSize(width: ((width - xInsets) / numberOfColumns), height: ((width - xInsets) / numberOfColumns))
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserData.shared.explorePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? ExploreCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = UserData.shared.explorePosts[indexPath.item].image
        return cell
    }
}
