//
//  GalleryCollectionViewCell.swift
//  MiniGram
//
//  Created by Diego Maceda on 3/4/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var galleryImageView: UIImageView!
    
    func updateImage(image: UIImage?) {
        self.galleryImageView.image = image ?? UIImage(named: "placeholder")
    }
}
