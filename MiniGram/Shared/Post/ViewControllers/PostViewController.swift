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
    var user: GenericUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.round()
        refreshData()
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func refreshData() {
        if let post = post {
            postImage.image = post.image
            likesLabel.text = String(post.likes.count)
            descTextView.text = post.desc
        }
        if let user = user {
            usernameLabel.text = user.userName
            userImage.image = user.image
        }
    }
    
    @IBAction func likeClick(_ sender: UIButton) {
        // Update Database instead of local.
        if (!sender.isSelected) {
            sender.isSelected = true
            post?.likes.append(user!.id)
            refreshData()
        } else {
            sender.isSelected = false
            post?.likes.removeAll(where: { (id) -> Bool in
                id == user!.id
            })
            refreshData()
        }
        
    }

}
