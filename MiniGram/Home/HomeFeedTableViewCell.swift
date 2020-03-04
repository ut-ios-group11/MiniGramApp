//
//  HomeFeedTableViewCell.swift
//  MiniGram
//
//  Created by Matthew Ewing on 3/4/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        // database call + update LikeCount
        
    }
    
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var caption: UITextView!
    
    @IBAction func viewCommentsButtonPressed(_ sender: Any) {
    }
    
    
}

