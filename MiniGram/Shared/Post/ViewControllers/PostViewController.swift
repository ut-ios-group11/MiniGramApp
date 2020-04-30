//
//  PostViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/28/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: GenericPost?
    let currentUser = UserData.shared.getDatabaseUser()
    var commentSegueIdentifier = "commentSegue"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.round()
        refreshData()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func refreshData() {
        if let post = post {
            postImage.image = post.image ?? UIImage(named: "placeholder")
            print("Number of likes: \(String(post.likes.count))")
            likesLabel.text = String(post.likes.count)
            descTextView.text = post.desc
            usernameLabel.text = post.userName
            
            // Set the profile image for the user who posted 
            userImage.image = post.userImage ?? UIImage(named: "placeholder")
            post.downloadUserImageIfMissing {
                self.userImage.image = post.userImage
            }
        }
        
        // post my already be liked by user, initialize button appropirately
        if post != nil {
            if (post?.likes.contains(currentUser!.id))! {
                likeButton.isSelected = true
            }
        }
    }
    
    @IBAction func likeClick(_ sender: UIButton) {
        guard let userId = UserData.shared.getDatabaseUser()?.id else {
            return
        }
        
        guard let postId = post?.id else {
            return
        }
        if (!sender.isSelected) {
            sender.isSelected = true
            Database.shared.likePost(currentUserId: userId, postToLikeId: postId, onError: {
                (error) in
                LogManager.logError(error)
            }) {
                LogManager.logInfo("\(userId) successfully liked post \(postId)")
                if (!((self.post?.likes.contains(userId))!)) {
                    self.likeButton.isSelected = true
                    self.post?.likes.append(userId)
                }
                self.refreshData()
            }
        } else {
            sender.isSelected = false
            Database.shared.unlikePost(currentUserId: userId, postToUnlikeId: postId, onError: {
                (error) in
                LogManager.logError(error)
            }) {
                LogManager.logInfo("\(userId) successfully unliked post \(postId)")
                self.post?.likes.removeAll(where: { (id) -> Bool in
                    id == userId
                })
                self.refreshData()
            }
        }
    }
    @IBAction func viewAllCommentsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: commentSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == commentSegueIdentifier,
            let nextVC = segue.destination as? CommentViewController {
                nextVC.post = post
        }
    }
}
