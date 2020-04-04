//
//  HomeViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

protocol HomeFeedPost {
    func viewComments()
    func likePost()
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeFeedPost {
    func viewComments() {
        // segue to a comment view
    }
    
    func likePost() {
        // update number of likes, update data on screen
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var explorePosts = [GenericPost]()
    var user: GenericUser?
    var commentSegueIdentifier = "commentSegue"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        explorePosts = UserData.shared.explorePosts
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        explorePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? HomeFeedTableViewCell else {
                return UITableViewCell()
        }
        cell.postImage.image = explorePosts[indexPath.row].image
        cell.userImage.image = explorePosts[indexPath.row].image
        cell.userImage.round()
//        cell.userImage.roundCorners(cell.userImage.frame.size.width / 2)
        cell.username.text = explorePosts[indexPath.row].userId
        cell.likeCount.text = String(explorePosts[indexPath.row].likes)
        cell.caption.text = explorePosts[indexPath.row].desc

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == commentSegueIdentifier,
            let nextVC = segue.destination as? CommentViewController {
            nextVC.user = user
//            nextVC.post =
        }
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
