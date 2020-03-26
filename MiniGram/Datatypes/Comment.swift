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
    var message: String
    var date: Timestamp
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        userId = doc.get("userId") as? String ?? ""
        message = doc.get("message") as? String ?? ""
        date = doc.get("date") as? Timestamp ?? Timestamp()
    }
    
    init(id: String, userId: String, message: String, date: Timestamp) {
        self.id = id
        self.userId = userId
        self.message = message
        self.date = date
    }
}

