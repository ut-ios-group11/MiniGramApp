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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.round()
        refreshData()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func refreshData() {
        if let post = post {
            postImage.image = post.image ?? UIImage(named: "placeholder")
            likesLabel.text = String(post.likes.count)
            descTextView.text = post.desc
            usernameLabel.text = post.userName
            
            // Set the profile image for the user who posted 
            userImage.image = post.userImage ?? UIImage(named: "placeholder")
            post.downloadUserImageIfMissing(onComplete: updateImage)
        }
        
        // post my already be liked by user, initialize button appropirately
        if currentUser != nil && post != nil {
            if (post?.likes.contains(currentUser!.id))! {
                likeButton.isSelected = true
            }
        }
    }
    
    func updateImage(image: UIImage?) {
        self.userImage.image = image ?? UIImage(named: "placeholder")
    }
    
    @IBAction func likeClick(_ sender: UIButton) {
        // Update Database instead of local.
        if (!sender.isSelected) {
            sender.isSelected = true
            post?.likes.append(currentUser!.id)
            refreshData()
        } else {
            sender.isSelected = false
            post?.likes.removeAll(where: { (id) -> Bool in
                id == currentUser!.id
            })
            refreshData()
        }
        
    }

}
