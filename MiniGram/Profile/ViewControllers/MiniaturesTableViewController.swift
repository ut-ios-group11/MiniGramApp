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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
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

        return model[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell",
                                                      for: indexPath)

        cell.backgroundColor = model[collectionView.tag][indexPath.item]

        return cell
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
