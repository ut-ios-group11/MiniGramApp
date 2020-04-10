//
//  CommentViewController.swift
//  MiniGram
//
//  Created by Matthew Ewing on 3/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit
import FirebaseFirestore



class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var explorePosts = [GenericPost]()

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var addCommentText: UITextField!
    
    @IBAction func buttonPressedAddComment(_ sender: Any) {
        if addCommentText.text != "" {
            let newComment = Comment(id: "uhhh...1", userId: user!.id, message: addCommentText.text!, date: Timestamp())
            post?.addComment(comment: newComment)
            addCommentText.text = ""
            tableView.reloadData()
        }
    }
    
    var post: GenericPost?
    var user: GenericUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        addCommentText.underlined()
        explorePosts = UserData.shared.explorePosts
        user = UserData.shared.exploreUsers[0]
        tableView.delegate = self
        tableView.dataSource = self
        userImage.image = user?.image
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (post?.comments.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
        }
        // need to be able to get the user from the userid...
        // too lazy to write a for loop over the generic users to find the one with the given ID for alpha.
        // will fix this for the beta with actual data from the db
//        cell.commentUserImage = ???
        cell.commentUsername.text = post?.comments[indexPath.row].userId
        cell.commentText.text = post?.comments[indexPath.row].message
        return cell
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
