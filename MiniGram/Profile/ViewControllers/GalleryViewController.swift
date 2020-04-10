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
        
        if let user = UserData.shared.getDatabaseUser() {
            user.setPostsRefreshFunction(refreshFunction: reloadGalleryPosts)
        }
        
        reloadGalleryPosts()
        
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
    
    func reloadGalleryPosts() {
        if let user = UserData.shared.getDatabaseUser() {
            galleryPosts = user.posts
            collectionView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
}
