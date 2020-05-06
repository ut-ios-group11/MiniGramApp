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
    @IBOutlet weak var backgroundTextInput: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var addCommentButton: UIButton!
    
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    @IBAction func buttonPressedAddComment(_ sender: Any) {
        addCommentButton.isUserInteractionEnabled = false
        spinner.startAnimating()
        guard let post = post, let msg = addCommentText.text else {
            addCommentButton.isUserInteractionEnabled = true
            spinner.stopAnimating()
            return
        }
        guard let user = UserData.shared.getDatabaseUser(), let userName = user.userName else {
            addCommentButton.isUserInteractionEnabled = true
            spinner.stopAnimating()
            return
        }
        if addCommentText.text == "" {
            addCommentButton.isUserInteractionEnabled = true
            spinner.stopAnimating()
            return
        }
        addCommentText.text = ""
        let newComment = Comment(id: "", userId: user.id, userName: userName, message: msg, date: Timestamp())
        Database.shared.createComment(postId: post.id, comment: newComment, onError: { (error) in
            LogManager.logError(error)
            self.spinner.stopAnimating()
            self.addCommentButton.isUserInteractionEnabled = true
        }) {
            LogManager.logInfo("Comment Created for post \(post.id)")
            self.spinner.stopAnimating()
            self.addCommentButton.isUserInteractionEnabled = true
        }
    }
    
    var post: GenericPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        userImage.round()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        backgroundTextInput.underlined()
        spinner.hidesWhenStopped = true
        spinner.roundCorners(4)
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
    
    // MARK: Handle Keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let keyboard = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardSize = keyboard.height
        
        var safeArea = 0 as CGFloat
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let bottomPadding = window?.safeAreaInsets.bottom
            safeArea = bottomPadding ?? 0
        }
        print(safeArea, keyboardSize)
        viewBottomConstraint.constant = (2 * safeArea) - keyboardSize
        
        guard let keyboardAnimationDuration = sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        let duration: TimeInterval = keyboardAnimationDuration.doubleValue
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {

        let info = sender.userInfo!
        guard let keyboardAnimationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        let duration: TimeInterval = keyboardAnimationDuration.doubleValue
        viewBottomConstraint.constant = 0
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (post?.comments.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
        }
        guard let post = post else { return UITableViewCell()}
        guard let user = UserData.shared.getDatabaseUser() else { return UITableViewCell() }
        let comment = post.comments[indexPath.row]

        cell.commentUsername.text = comment.userName
        cell.commentText.text = comment.message
        cell.commentUserImage.round()
        if comment.userName == user.userName {
            cell.commentUserImage.image = user.image
        } else {
            cell.commentUserImage.image = comment.image ?? UIImage(named: "placeholder")
            comment.downloadImageIfMissing {
                DispatchQueue.main.async {
                    if tableView.hasRowAtIndexPath(indexPath: indexPath) {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }

            }
            
        }
        
        return cell
    }

}
