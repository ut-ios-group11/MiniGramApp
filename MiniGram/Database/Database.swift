//
//  Database.swift
//  MiniGramApp
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage

/*
 Point to consolidate what we send to database to make sure we
 dont forget data fields and whatnot.
 */

class Database {
    
    private init() {}
    static let shared = Database()
    
    let db = Firestore.firestore()
    
    /*
     Recommended Ex:
     
         func createDatabaseUser(user: DatabaseUser, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
         
         }
     */
    
    // MARK: - Create Methods
    
    // MARK: - Update Methods
    
    // MARK: - Check Methods
    
    // MARK: - Delete Methods
    
}
