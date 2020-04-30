//
//  HomeViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

protocol HomeFeedPost {
    func viewComments(postId: String)
    func viewProfile(postId: String)
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeFeedPost {
    
    func viewComments(postId: String) {
        seguePostId = postId
        performSegue(withIdentifier: commentSegueIdentifier, sender: self)
    }
    
    func viewProfile(postId: String) {
        let users = UserData.shared.getUserList()
        var selectedPost: GenericPost?
        for post in posts {
            if post.id == postId {
                selectedPost = post
                break
            }
        }
        if users.count == 0 {
            LogManager.logError("Problem")
        }
        for user in users {
            if user.id == selectedPost?.userId {
                userToDisplay = user
                break
            }
        }
        if userToDisplay == nil {
            LogManager.logError("No work")
            return
        }
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [GenericPost]()
    var commentSegueIdentifier = "commentSegue"
    var profileSegueIdentifier = "toProfile"
    var seguePostId: String?
    var segueUserPostId: String?
    var userToDisplay: GenericUser?


    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        reloadData()
        UserData.shared.setHomePostsRefreshFunction(with: reloadData)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // display no followers message
    }
    
    func reloadData() {
        posts = UserData.shared.getHomePosts()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count < 1 {
            return 1
        }
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if posts.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? HomeFeedTableViewCell else {
                return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.likeButton.isSelected = false
        
        if post.image == nil {
            cell.spinner.startAnimating()
            cell.postImage.image = UIImage(named: "placeholder")
        } else {
            cell.postImage.image = post.image!
        }
        post.downloadImageIfMissing {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.userImage.image = post.userImage ?? UIImage(named: "placeholder")
        post.downloadUserImageIfMissing {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.userImage.round()
        cell.username.setTitle(post.userName, for: .normal)
        cell.likeCount.text = String(post.likes.count)
        let user = UserData.shared.getDatabaseUser()
        if post.likes.contains(user?.id ?? "") {
            cell.likeButton.isSelected = true
        }
        cell.caption.text = post.desc
        cell.postId = post.id
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == commentSegueIdentifier,
            let nextVC = segue.destination as? CommentViewController {
            if let post = posts.first(where: { (GenericPost) -> Bool in
                return GenericPost.id == seguePostId
            }) {
                nextVC.post = post
            }
        }
        
        if let nav = segue.destination as? UINavigationController {
            if let vc = nav.topViewController as? ProfileViewController {
                userToDisplay?.startPostsListening()
                userToDisplay?.startMiniatureListening()
                vc.profileToDisplay = userToDisplay
            }
        }
    }
    
    @IBAction func prepareForUnwindWithSegue(segue: UIStoryboardSegue) {
        
    }
}
