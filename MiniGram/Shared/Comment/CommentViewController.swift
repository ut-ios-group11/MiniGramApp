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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var addCommentText: UITextView!
    
    @IBAction func buttonPressedAddComment(_ sender: Any) {
        guard let post = post, let msg = addCommentText.text else {
            return
        }
        guard let user = UserData.shared.getDatabaseUser(), let userName = user.userName else {
            return
        }
        addCommentText.text = ""
        let newComment = Comment(id: "", userId: user.id, userName: userName, message: msg, date: Timestamp())
        Database.shared.createComment(postId: post.id, comment: newComment, onError: { (error) in
            LogManager.logError(error)
        }) {
            LogManager.logInfo("Comment Created for post \(post.id)")
        }
    }
    
    var post: GenericPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        addCommentText.addBottomBorderWithColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        post?.setCommentsRefreshFunction(reloadData)
        post?.startCommentListenerIfDoesntExits()
        reloadData()
    }
    
    func reloadData() {
        let user = UserData.shared.getDatabaseUser()
        userImage.image = user?.image ?? UIImage(named: "placeholder")
        
        tableView.reloadData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height + 15)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (post?.comments.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
        }
        guard let post = post else { return UITableViewCell()}
        let comment = post.comments[indexPath.row]

        cell.commentUsername.text = comment.userName
        cell.commentText.text = comment.message
        cell.commentUserImage.image = comment.image ?? UIImage(named: "placeholder")
        comment.downloadImageIfMissing {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }

}
