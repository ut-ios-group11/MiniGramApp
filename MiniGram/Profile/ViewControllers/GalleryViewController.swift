//
//  GalleryViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 3/3/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let collectionViewXInset: CGFloat = 10
    var galleryPosts = [GenericPost]()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        collectionViewSetUp()
        
        galleryPosts = UserData.shared.galleryPosts
        
        collectionView.reloadData()
     }
    
    func collectionViewSetUp() {
        // Setting Delegates
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Setting the layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: collectionViewXInset, bottom: 0, right: collectionViewXInset)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets = collectionViewXInset * 2
        return CGSize(width: ((width - xInsets) / numberOfColumns), height: ((width - xInsets) / numberOfColumns))
    }
}

// MARK: Collection View DataSource

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.galleryImageView.image = galleryPosts[indexPath.item].image
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clickOnGalleryPostSegue" {
            if let postVC = segue.destination as? PostViewController {
                postVC.post = sender as? GenericPost
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Perform segue to post and send in post and user
        performSegue(withIdentifier: "clickOnGalleryPostSegue", sender: galleryPosts[indexPath.item])
    }
}
