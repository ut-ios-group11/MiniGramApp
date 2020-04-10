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
    func createUser(email: String, password: String, username: String, name: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        FireAuth.shared.createUser(email: email, password: password, onError: onError) { (user) in
            let uid = user.uid
            let data = ["username": username, "name": name]
            let reference = Firestore.firestore().collection(FireCollection.Users.rawValue)
            Fire.shared.create(at: reference, withID: uid, data: data, onError: onError, onComplete: onComplete)
        }
    }
    
    func createPost() {
        
    }
    
    func createMinature() {
        
    }
    
    // MARK: - Update Methods
    
    // Minatures
    func updateMinature() {
        
    }
    
    // Profile
    func updateProfile() {
        
    }
    
    func updateProfilePhoto() {
        
    }
    
    func updateUserPassword() {
        
    }
    
    // MARK: - Listener Methods
    
    func profileListener() {
        
    }
    
    func profilePostsListener(onComplete: @escaping ([GenericPost], [String], [GenericPost], String) -> Void, userId: String, listenerId: String) -> Listener {
        let postsRef = db.collection("Posts")
        let query = postsRef.whereField("userId", isEqualTo: userId)

        // Create a listener registration
        let profileListenerRegistration = Fire.shared.listener(at: query, returning: GenericPost.self, onComplete: onComplete)
        
        let listener = Listener(id: listenerId, registration: profileListenerRegistration)
        return listener
    }
    
    func profileMinaturesListener() {
        
    }
    
    // MARK: - Check Methods
    
    // MARK: - Delete Methods
    
}
