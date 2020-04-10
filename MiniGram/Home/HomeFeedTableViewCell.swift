//
//  HomeFeedTableViewCell.swift
//  MiniGram
//
//  Created by Matthew Ewing on 3/4/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {
    
    var delegate: HomeFeedPost?
    
    var postId: String?
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        // update UI and call function to record like in database
        if (!sender.isSelected) {
            sender.isSelected = true
            likeCount.text = String(Int(likeCount.text!)! + 1)
        } else {
            sender.isSelected = false
            likeCount.text = String(Int(likeCount.text!)! - 1)
        }
        // must negate isSelected for this call because we just reversed it above
        delegate?.likePost(postId: postId!, selected: !sender.isSelected)
    }
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var caption: UITextView!
    
    @IBAction func viewCommentsButtonPressed(_ sender: Any) {
        // call function to segue to the comment view
        delegate?.viewComments(postId: postId!)
    }
    
}

