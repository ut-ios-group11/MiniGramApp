//
//  GenericPost.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import Firebase

class GenericPost: FireInitable {
    
    var id: String
    var userId: String
    var userName: String
    var date: Timestamp
    var desc: String
    var likes: [String]
    var image: UIImage?
    var comments = [Comment]()
    var userImage: UIImage?
    
    private var commentListener: Listener?
    private var commentsRefreshFunction: (() -> Void)?
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        userId = doc.get("userId") as? String ?? ""
        userName = doc.get("userName") as? String ?? ""
        likes = doc.get("likes") as? [String] ?? [""]
        date = doc.get("date") as? Timestamp ?? Timestamp()
        desc = doc.get("desc") as? String ?? ""
    }
    
    init (id: String, userId: String, userName: String, likes:[String], desc: String, date: Timestamp, image: UIImage?) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.likes = likes
        self.date = date
        self.desc = desc
        self.image = image
    }
    
    func update(with post: GenericPost) {
        desc = post.desc
        likes = post.likes
    }
    
    func downloadImageIfMissing(onComplete: (() -> Void)? = nil) {
        if image == nil {
            downloadImage(onComplete: onComplete)
        }
    }
    
    func downloadImageForced(onComplete: (()-> Void)? = nil) {
        downloadImage(onComplete: onComplete)
    }
    
    private func downloadImage(onComplete: (()-> Void)? = nil) {
        Database.shared.downloadPostImage(id: id, onError: { (error) in
            LogManager.logError(error)
        }) { (image) in
            self.image = image
            LogManager.logInfo("Image for post \(self.id) downloaded")
            onComplete?()
        }
    }
    
    func downloadUserImageIfMissing(onComplete: (() -> Void)? = nil) {
        if userImage == nil {
            downloadUserImage(onComplete: onComplete)
        }
    }
    
    func downloadUserImageForced(onComplete: (()-> Void)? = nil) {
        downloadUserImage(onComplete: onComplete)
    }
    
    private func downloadUserImage(onComplete: (()-> Void)? = nil) {
        Database.shared.downloadProfileImage(id: userId, onError: { (error) in
            LogManager.logError(error)
        }) { (image) in
            self.userImage = image
            LogManager.logInfo("Image for user \(self.userId) downloaded")
            onComplete?()
        }
    }
    
    func downloadUserImageIfMissing(onComplete: ((UIImage) -> Void)? = nil) {
        if userImage == nil {
            downloadUserImage(onComplete: onComplete)
        }
    }

    func downloadUserImageForced(onComplete: ((UIImage)-> Void)? = nil) {
        downloadUserImage(onComplete: onComplete)
    }

    private func downloadUserImage(onComplete: ((UIImage)-> Void)? = nil) {
        Database.shared.downloadProfileImage(id: userId, onError: { (error) in
            LogManager.logError(error)
        }) { (image) in
            self.userImage = image
            LogManager.logInfo("Image for user \(self.userId) downloaded")
            onComplete?(image)
        }
    }
    
    func addComment (comment: Comment) {
        comments.append(comment)
    }
    
    func startCommentListenerIfDoesntExits() {
        if commentListener != nil {
            return
        }
        commentListener = Database.shared.postCommentListener(postId: id, listenerId: "Comments", onComplete: commentListenerRead(add:remove:change:listenerId:))
    }
    
    func commentListenerRead(add: [Comment], remove: [String], change: [Comment], listenerId: String) {
        //add
        for comment in add {
            //self.comments.append(comment)
            let index = self.comments.insertionIndexOf(comment) { $0.date.dateValue() < $1.date.dateValue()}
            self.comments.insert(comment, at: index)
        }
        //remove
        for id in remove {
            self.comments.removeAll(where: {$0.id == id})
        }
        //change
        for comment in change {
            self.comments.first(where: {$0.id == comment.id})?.update(with: comment)
        }
        commentsRefreshFunction?()
    }
    
    func setCommentsRefreshFunction(_ function: (() -> Void)?) {
        commentsRefreshFunction = function
    }
    
    func toDict() -> [String : Any] {
        return [
            "desc": desc,
            "date": date,
            "likes": likes,
            "userId": userId,
            "userName": userName
        ]
    }
    
    deinit {
        commentListener?.registration.remove()
        commentsRefreshFunction = nil
    }
    
}
