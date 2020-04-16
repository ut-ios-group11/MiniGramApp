//
//  MiniaturesTableViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 3/24/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class MiniaturesTableViewController: UITableViewController {

    var miniaturePosts = [String: [GenericMini]]()
    var downloadedMiniaturePosts = [GenericMini]()
    let cellSpacingHeight: CGFloat = 16
    
    var userToDisplay: GenericUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 200
        self.tableView.allowsSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if let user = userToDisplay {
            user.setMinisRefreshFunction(refreshFunction: reloadMiniaturePosts)
            reloadMiniaturePosts()
        }
    }
    
    func setUser(_ user: GenericUser?) {
        userToDisplay = user
    }
    
    func reloadMiniaturePosts() {
        if let user = userToDisplay {
            miniaturePosts.removeAll()
            downloadedMiniaturePosts = user.minis
            // Transform 1D array into dict with each entry being a unit name and corresponding GenericMinis
            for mini in downloadedMiniaturePosts {
                if miniaturePosts[mini.unit!] == nil {
                    miniaturePosts[mini.unit!] = [GenericMini]()
                }
                miniaturePosts[mini.unit!]!.append(mini)
            }
            // Reload the data
            tableView.reloadData()
        }
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MiniaturesTableViewCell
        
        cell.unitLabel.text = Array(miniaturePosts.keys)[indexPath.section]
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 0
        cell.clipsToBounds = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? MiniaturesTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
    }
}

extension MiniaturesTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
//        collectionView.reloadData()
        return Array(miniaturePosts.values)[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? MiniaturesCollectionViewCell else { return UICollectionViewCell() }
        
        // Get the proper mini to display
        let key = Array(miniaturePosts.keys)[collectionView.tag]
        let array = miniaturePosts[key]
        let mini = array![indexPath.item]
        
        // Set the mini's image and download if missing
        cell.miniaturesImageView.image = mini.image
        mini.downloadImageIfMissing(onComplete: cell.updateImage)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clickOnMiniatureSegue" {
            if let miniatureVC = segue.destination as? MiniatureViewController {
                miniatureVC.mini = sender as? GenericMini
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Perform segue to post and send in post and user
        let key = Array(miniaturePosts.keys)[collectionView.tag]
        let array = miniaturePosts[key]
        let mini = array![indexPath.item]

        performSegue(withIdentifier: "clickOnMiniatureSegue", sender: mini)
    }
}

extension MiniaturesTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
}
