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
    @IBOutlet weak var searchBarTextField: UITextField!
    
    var postToDisplay: GenericPost?
    
    // MARK: Constants
    let collectionViewXInset: CGFloat = 10
    
    var explorePosts = [GenericPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarTextField.underlined()
        searchBarTextField.delegate = self
        collectionViewSetUp()
        
        explorePosts = UserData.shared.getExplorePosts()
        
        UserData.shared.setExplorePostsRefreshFunction(with: reloadData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    func reloadData() {
        explorePosts = UserData.shared.getExplorePosts()
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PostViewController {
            vc.post = postToDisplay
            vc.user = UserData.shared.exploreUsers.first(where: { (user) -> Bool in
                return user.id == postToDisplay?.id
            })
        }
    }
}

// MARK: Search Bar Text Field Delegate

extension ExploreViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBarTextField.endEditing(true)
        performSegue(withIdentifier: "toSearch", sender: self)
    }
}

// MARK: Collection View Flow Layout

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets = collectionViewXInset * 2
        return CGSize(width: ((width - xInsets) / numberOfColumns), height: ((width - xInsets) / numberOfColumns))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postToDisplay = explorePosts[indexPath.item]
        performSegue(withIdentifier: "toPost", sender: self)
    }
}

// MARK: Collection View DataSource

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return explorePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? ExploreCollectionViewCell else {
            return UICollectionViewCell()
        }
        let post = explorePosts[indexPath.item]
        cell.imageView.image = post.image ?? UIImage(named: "placeholder")
        post.downloadImageIfMissing {
            collectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
}
