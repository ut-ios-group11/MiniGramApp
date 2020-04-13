//
//  MiniaturesTableViewCell.swift
//  MiniGram
//
//  Created by Diego Maceda on 3/24/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class MiniaturesTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var unitLabel: UILabel!
    var cellData = [GenericMini]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Set the delegate, datasource, and row number on the collectionView
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}
