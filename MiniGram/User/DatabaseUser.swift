//
//  DatabaseUser.swift
//  MiniGram
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import Firebase

class DatabaseUser: FireInitable {
    
    var id: String
    var name: String?
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        name = doc.get("name") as? String
    }
    
}
