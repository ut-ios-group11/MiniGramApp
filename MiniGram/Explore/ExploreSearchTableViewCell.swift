//
//  ExploreSearchTableViewCell.swift
//  MiniGram
//
//  Created by Keegan Black on 2/27/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class ExploreSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.roundCorners(30)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
