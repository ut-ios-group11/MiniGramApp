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
        guard let userId = UserData.shared.getDatabaseUser()?.id else {
            return
        }
        
        if (!sender.isSelected) {
            sender.isSelected = true
            Database.shared.likePost(currentUserId: userId, postToLikeId: postId!, onError: {
                (error) in
                LogManager.logError(error)
            }) {
                LogManager.logInfo("\(userId) successfully liked post \(self.postId!)")
//                self.post?.likes.append(userId)
//                self.refreshData()
            }
            likeCount.text = String(Int(likeCount.text!)! + 1)
        } else {
            sender.isSelected = false
            Database.shared.unlikePost(currentUserId: userId, postToUnlikeId: postId!, onError: {
                (error) in
                LogManager.logError(error)
            }) {
                LogManager.logInfo("\(userId) successfully unliked post \(self.postId!)")
            }
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

