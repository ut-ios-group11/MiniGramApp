//
//  GenericUser.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import Firebase

class GenericUser: FireInitable {
    
    var id: String
    var name: String?
    var followers: [String]?
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        name = doc.get("name") as? String
        followers = doc.get("followers") as? [String]
    }
    
}
