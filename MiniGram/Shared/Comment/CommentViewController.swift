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
    
    @IBOutlet weak var addCommentText: UITextView!
    
    
    @IBAction func buttonPressedAddComment(_ sender: Any) {
        if addCommentText.text != "" {
            let newComment = Comment(id: "uhhh...1", userId: user?.userName! ?? "placeholder", message: addCommentText.text!, date: Timestamp())
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
//        addCommentText.underlined()
        explorePosts = UserData.shared.getExplorePosts()
        tableView.delegate = self
        tableView.dataSource = self
        userImage.image = user?.image ?? UIImage(named: "placeholder")
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
        addCommentText.addBottomBorderWithColor()
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
        // must be fixed when we use database connection
//        cell.commentUserImage = ???
        cell.commentUsername.text = post?.comments[indexPath.row].userId
        cell.commentText.text = post?.comments[indexPath.row].message
        cell.commentUserImage.image = user?.image ?? UIImage(named: "placeholder")
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
