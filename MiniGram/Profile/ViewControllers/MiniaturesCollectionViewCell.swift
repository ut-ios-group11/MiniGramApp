//
//  MiniaturesCollectionViewCell.swift
//  MiniGram
//
//  Created by Diego Maceda on 4/10/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class MiniaturesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var miniaturesImageView: UIImageView!
    
    func updateImage(image: UIImage?) {
        self.miniaturesImageView.image = image ?? UIImage(named: "placeholder")
    }

}

