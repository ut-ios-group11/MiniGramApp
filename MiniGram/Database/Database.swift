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
    
    // MARK: - Create Methods
    
    func createUser(email: String, password: String, username: String, name: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        FireAuth.shared.createUser(email: email, password: password, onError: onError) { (user) in
            let uid = user.uid
            let data = ["userName": username, "name": name]
            let reference = Firestore.firestore().collection(FireCollection.Users.rawValue)
            Fire.shared.create(at: reference, withID: uid, data: data, onError: onError, onComplete: onComplete)
            let fsReference = FireStorageCollection.Users
            Fire.shared.uploadImage(at: fsReference, id: uid, image: UIImage(named: "placeholder")!, onError: onError, onComplete: onComplete)
        }
    }
    
    func createPost( image: UIImage, post: GenericPost, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let reference = Firestore.firestore().collection(FireCollection.Posts.rawValue)
        let id = reference.document().documentID
        let data = post.toDict()
        Fire.shared.create(at: reference, withID: id, data: data, onError: onError) {
            let fsReference = FireStorageCollection.Posts
            Fire.shared.uploadImage(at: fsReference, id: id, image: image, onError: onError, onComplete: onComplete)
        }
    }
    
    func createMinature(image: UIImage, miniature: GenericMini, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let reference = Firestore.firestore().collection(FireCollection.Miniatures.rawValue)
        let id = reference.document().documentID
        let data = miniature.toDict()
        Fire.shared.create(at: reference, withID: id, data: data, onError: onError) {
            let fsReference = FireStorageCollection.Miniatures
            Fire.shared.uploadImage(at: fsReference, id: id, image: image, onError: onError, onComplete: onComplete)
        }
    }
    
    // MARK: - Update Methods
    
    func updateProfile(name: String? = nil, userName: String? = nil, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        guard let user = UserData.shared.getDatabaseUser() else { return }
        let newName = name ?? user.name
        let newUserName = userName ?? user.userName
        let reference = Firestore.firestore().collection(FireCollection.Users.rawValue).document(user.id)
        let data = ["name": newName, "userName": newUserName]
        Fire.shared.update(at: reference, data: data as [String : Any], onError: onError, onComplete: onComplete)
    }
    
    func updateEmail(email: String, password: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        FireAuth.shared.updateEmail(newEmail: email, password: password, onError: onError, onComplete: onComplete)
    }
    
    func updateProfilePhoto(image: UIImage, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let fsReference = FireStorageCollection.Users
        guard let user = UserData.shared.getDatabaseUser() else { return }
        Fire.shared.uploadImage(at: fsReference, id: user.id, image: image, onError: onError, onComplete: onComplete)
    }
    
    func updateUserPassword(newPassword: String, oldPassword: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        FireAuth.shared.updatePassword(oldPassword: oldPassword, newPassword: newPassword, onError: onError, onComplete: onComplete)
    }
    
    func followUser(currentUserId: String, userToFollowId: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let data = [
            "following": Fire.shared.arrayUnion(data: [userToFollowId])
        ]
        let ref = Firestore.firestore().collection(FireCollection.Users.rawValue).document(currentUserId)
        Fire.shared.update(at: ref, data: data, onError: onError, onComplete: onComplete)
    }
    
    func unFollowUser(currentUserId: String, userToUnFollowId: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let data = [
            "following": Fire.shared.arrayRemove(data: [userToUnFollowId])
        ]
        let ref = Firestore.firestore().collection(FireCollection.Users.rawValue).document(currentUserId)
        Fire.shared.update(at: ref, data: data, onError: onError, onComplete: onComplete)
    }
    
    func likePost(currentUserId: String, postToLikeId: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let data = [
            "likes": Fire.shared.arrayUnion(data: [currentUserId])
        ]
        
        let ref = Firestore.firestore().collection(FireCollection.Posts.rawValue).document(postToLikeId)
        Fire.shared.update(at: ref, data: data, onError: onError, onComplete: onComplete)
    }
    
    func unlikePost(currentUserId: String, postToUnlikeId: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let data = [
            "likes": Fire.shared.arrayRemove(data: [currentUserId])
        ]
        
        let ref = Firestore.firestore().collection(FireCollection.Posts.rawValue).document(postToUnlikeId)
        Fire.shared.update(at: ref, data: data, onError: onError, onComplete: onComplete)
    }

    // MARK: - Single Download
    
    func downloadProfileImage(id: String, onError: @escaping (Error) -> Void, onComplete: @escaping (UIImage) -> Void) {
        Fire.shared.downloadImage(at: FireStorageCollection.Users, id: id, OnError: onError, onComplete: onComplete)
    }
    
    func downloadPostImage(id: String, onError: @escaping (Error) -> Void, onComplete: @escaping (UIImage) -> Void) {
        Fire.shared.downloadImage(at: FireStorageCollection.Posts, id: id, OnError: onError, onComplete: onComplete)
    }
    
    func downloadMiniatureImage(id: String, onError: @escaping (Error) -> Void, onComplete: @escaping (UIImage) -> Void) {
        Fire.shared.downloadImage(at: FireStorageCollection.Miniatures, id: id, OnError: onError, onComplete: onComplete)
    }
    
    func downloadCommentImage(id: String, onError: @escaping (Error) -> Void, onComplete: @escaping (UIImage) -> Void) {
        Fire.shared.downloadImage(at: FireStorageCollection.Users, id: id, OnError: onError, onComplete: onComplete)
    }
    
    // MARK: - Listener Methods
    
    func profilePostsListener(listenerId: String, userId: String, onComplete: @escaping ([GenericPost], [String], [GenericPost], String) -> Void) -> Listener {
        let query = Firestore.firestore().collection(FireCollection.Posts.rawValue).whereField("userId", isEqualTo: userId)
        // Create a listener registration
        let profileListenerRegistration = Fire.shared.listener(at: query, returning: GenericPost.self, onComplete: onComplete)
        
        return Listener(id: listenerId, registration: profileListenerRegistration)
    }
    
    func profileMiniaturesListener(listenerId: String, userId: String, onComplete: @escaping ([GenericMini],[String],[GenericMini], String) -> Void) -> Listener {
        let query = Firestore.firestore().collection(FireCollection.Miniatures.rawValue).whereField("userId", isEqualTo: userId)
        let listenerRegistration = Fire.shared.listener(at: query, returning: GenericMini.self, onComplete: onComplete)
        return Listener(id: listenerId, registration: listenerRegistration)
    }
    
    func allPostsListener(listenerId: String, onComplete: @escaping ([GenericPost],[String],[GenericPost], String) -> Void) -> Listener {
        let query = Firestore.firestore().collection(FireCollection.Posts.rawValue)
        let listenerRegistration = Fire.shared.listener(at: query, returning: GenericPost.self, onComplete: onComplete)
        return Listener(id: listenerId, registration: listenerRegistration)
    }
    
    func allUsersListener(listenerId: String, onComplete: @escaping ([GenericUser],[String],[GenericUser], String) -> Void) -> Listener {
        let query = Firestore.firestore().collection(FireCollection.Users.rawValue)
        let listenerRegistration = Fire.shared.listener(at: query, returning: GenericUser.self, onComplete: onComplete)
        return Listener(id: listenerId, registration: listenerRegistration)
    }
    
    func postCommentListener(postId: String, listenerId: String, onComplete: @escaping ([Comment],[String],[Comment], String) -> Void) -> Listener {
        let query = Firestore.firestore().collection(FireCollection.Posts.rawValue).document(postId).collection(FireSubCollection.Comments.rawValue)
        let listenerRegistration = Fire.shared.listener(at: query, returning: Comment.self, onComplete: onComplete)
        return Listener(id: listenerId, registration: listenerRegistration)
    }
    // MARK: - Check Methods
    
    // MARK: - Delete Methods
    
}
