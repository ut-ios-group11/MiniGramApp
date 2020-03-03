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
    var date: Timestamp
    var desc: String
    var likes: Int
    var image: UIImage?
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        userId = doc.get("userId") as? String ?? ""
        likes = doc.get("likes") as? Int ?? 0
        date = doc.get("date") as? Timestamp ?? Timestamp()
        desc = doc.get("desc") as? String ?? ""
    }
    
    init (id: String, userId:String, likes:Int, desc: String, date: Timestamp, image: UIImage?) {
        self.id = id
        self.userId = userId
        self.likes = likes
        self.date = date
        self.desc = desc
        self.image = image
    }
    
}
