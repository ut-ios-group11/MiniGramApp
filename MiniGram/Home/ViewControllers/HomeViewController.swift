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
    func likePost(postId: String, selected: Bool)
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeFeedPost {
    
    func viewComments(postId: String) {
        seguePostId = postId
        performSegue(withIdentifier: commentSegueIdentifier, sender: self)
    }
    
    func likePost(postId: String, selected: Bool) {
        // for local usage only. needs to be changed for db functionality.
//        var foundPost: GenericPost? = nil
//        for post in posts {
//            if post.id == postId {
//                foundPost = post
//            }
//        }
//        if foundPost != nil {
//            let user = getUser(userName: foundPost!.userId)
//            if !selected {
//                foundPost?.likes.append(user.id)
//            } else {
//                foundPost?.likes.removeAll(where: { (id) -> Bool in
//                    id == user.id
//                })
//            }
//        }
    }
    
    
    @IBOutlet weak var noFollowersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [GenericPost]()
    var commentSegueIdentifier = "commentSegue"
    var seguePostId: String?

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
        if posts.count == 0 {
             noFollowersLabel.isHidden = false
        } else {
             noFollowersLabel.isHidden = true
        }
    }
    
    func reloadData() {
        posts = UserData.shared.getHomePosts()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? HomeFeedTableViewCell else {
                return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.postImage.image = post.image ?? UIImage(named: "placeholder")
        post.downloadImageIfMissing {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        cell.userImage.image = post.userImage ?? UIImage(named: "placeholder")
        post.downloadUserImageIfMissing {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        cell.userImage.round()
        cell.username.text = post.userId
        cell.likeCount.text = String(post.likes.count)
        // account for fact that user may have already liked post when loading data
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
//                nextVC.user = getUser(userName: post.userId)
                nextVC.post = post
            }
        }
    }
    
    @IBAction func prepareForUnwindWithSegue(segue: UIStoryboardSegue) {
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
