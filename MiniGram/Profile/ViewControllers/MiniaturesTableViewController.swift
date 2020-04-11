//
//  MiniaturesTableViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 3/24/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class MiniaturesTableViewController: UITableViewController {

    let model: [[UIColor]] = generateRandomData()
    var miniaturePosts = [[GenericPost]]()
    let cellSpacingHeight: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 200
        self.tableView.allowsSelection = false
        miniaturePosts = [UserData.shared.galleryPosts]

        view.translatesAutoresizingMaskIntoConstraints = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return miniaturePosts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 0
        cell.clipsToBounds = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? MiniaturesTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}

extension MiniaturesTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        return miniaturePosts[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell",
                                                            for: indexPath) as? MiniaturesCollectionViewCell else {
                                                                return UICollectionViewCell()
        }

        cell.miniaturesImageView.image = miniaturePosts[collectionView.tag][indexPath.item].image

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clickOnMinisPostSegue" {
            if let postVC = segue.destination as? PostViewController {
                postVC.post = sender as? GenericPost
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Perform segue to post and send in post and user
        performSegue(withIdentifier: "clickOnMinisPostSegue", sender: miniaturePosts[collectionView.tag][indexPath.item])
    }
}

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 20
    let numberOfItemsPerRow = 15

    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {

        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

extension MiniaturesTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
}
