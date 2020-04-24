//
//  UserData.swift
//  MiniGram
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserData {

    enum UserDataError: Error {
        case couldNotLoadUser
        case noSignedInUser
    }
    static let shared = UserData()

    // Only Use Private Variables
    private var user: User?
    private var databaseUser: GenericUser?
    private var userListener: Listener?
    private var userRefreshFunction: ((GenericUser) -> Void)?

    // Only For Alpha
    public var explorePosts = [GenericPost]()
    public var exploreUsers = [GenericUser]()
    
    private init () {
        //For Testing Only
        createTestData()
    }

    private func clearAllData() {
        user = nil
        databaseUser = nil
        userListener?.registration.remove()
        userListener = nil
        userRefreshFunction = nil
    }

    public func getDatabaseUser() -> GenericUser? {
        return self.databaseUser
    }
    
    // MARK: - Sign in/out

    public func signOut(onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        FireAuth.shared.signOut(onError: onError) {
            self.clearAllData()
            onComplete()
        }
    }
    
    public func tryAutoSignIn(onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        if let user = FireAuth.shared.isUserSignedIn() {
            self.user = user
            readUser(id: user.uid, onError: onError, onComplete: {
                self.startUserListener(id: user.uid)
                onComplete()
            })
        } else {
            onError(UserDataError.noSignedInUser)
        }
    }

    public func signIn(email: String, password: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        if FireAuth.shared.isUserSignedIn() != nil {
            FireAuth.shared.signOut(onError: onError, onComplete: {
                self.signInHelper(email: email, password: password, onError: onError, onComplete: onComplete)
            })
        } else {
            self.signInHelper(email: email, password: password, onError: onError, onComplete: onComplete)
        }
    }
    private func signInHelper(email: String, password: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        FireAuth.shared.signIn(login: email, pass: password, onError: onError) { (user) in
            self.user = user
            self.readUser(id: user.uid, onError: onError, onComplete: {
                self.startUserListener(id: user.uid)
                onComplete()
            })
        }
    }
    
    private func readUser(id: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let query = Firestore.firestore().collection(FireCollection.Users.rawValue).document(id)
        Fire.shared.read(at: query, returning: GenericUser.self, onError: onError, onComplete: { (databaseUser) in
            guard let databaseUser = databaseUser else {
                onError(UserDataError.couldNotLoadUser)
                return
            }
            self.databaseUser = databaseUser
            self.databaseUser?.downloadImageIfMissing()
            databaseUser.startPostsListening()
            databaseUser.startMiniatureListening()
            onComplete()
        })
    }
    
    // MARK: - User Listener Functions
    
    private func startUserListener(id: String) {
        userListener?.registration.remove()
        let ref = Firestore.firestore().collection(FireCollection.Users.rawValue).document(id)
        let listenerReg = Fire.shared.listener(at: ref, returning: GenericUser.self, onComplete: userListenerRead(profileUpdate:))
        userListener = Listener(id: "user", registration: listenerReg)
    }
    
    private func userListenerRead(profileUpdate: GenericUser) {
        databaseUser?.update(with: profileUpdate)
        if let databaseUser = databaseUser {
            userRefreshFunction?(databaseUser)
        }
    }
    
    public func setUserRefreshFunction(with function: ((GenericUser) -> Void)?) {
        userRefreshFunction = function
    }
    
    public func getUserEmail() -> String? {
        return user?.email
    }
    
    public func getUserReloadedEmail(onComplete: @escaping (String) -> Void) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            if error == nil, let email = Auth.auth().currentUser?.email{
                onComplete(email)
            }
        })
    }

    // MARK: TEST DATA
    private func createTestData() {
        // Explore Posts
        for i in 0...6 {
            let newPost = GenericPost(id: "\(i)", userId: "TestUser\(i)", userName: "testusername", likes: ["user1", "user2", "user3"], desc: "lorem ipsum something something something. #something", date: Timestamp(), image: UIImage(named: "minature\(Int.random(in: 0 ..< 3))"))
            for j in 0...2 {
                let comment = Comment(id: "\(j)", userId: "TestUser\(i)", message: "this is a comment. Specifically comment number \(j) created by user \(i)", date: Timestamp())
                newPost.addComment(comment: comment)
            }
            explorePosts.append(newPost)
        }

        // Explore Users
        for i in 0...6 {
            let newUser = GenericUser(id: "\(i)", userName: "TestUser\(i)", name: "User\(i)", followers: nil, image: UIImage(named: "u\(i)"))
            exploreUsers.append(newUser)
        }
        
    }
}
