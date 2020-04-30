//
//  Comment.swift
//  MiniGram
//
//  Created by Keegan Black on 3/4/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import Firebase

class Comment: FireInitable {
    var id: String
    var userId: String
    var userName: String
    var message: String
    var date: Timestamp
    var image: UIImage?
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        userId = doc.get("userId") as? String ?? ""
        userName = doc.get("userName") as? String ?? ""
        message = doc.get("message") as? String ?? ""
        date = doc.get("date") as? Timestamp ?? Timestamp()
    }
    
    func update(with comment: Comment) {
        userId = comment.userId
        message = comment.message
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
        Database.shared.downloadCommentImage(id: userId, onError: { (error) in
            LogManager.logError(error)
        }) { (image) in
            self.image = image
            LogManager.logInfo("Image for post \(self.id) downloaded")
            onComplete?()
        }
    }
    
    init(id: String, userId: String, userName: String, message: String, date: Timestamp) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.message = message
        self.date = date
    }
    
    func toDict() -> [String : Any] {
        return [
            "userId": userId,
            "userName": userName,
            "message": message,
            "date": date
        ]
    }
}

