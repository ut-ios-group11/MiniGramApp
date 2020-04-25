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
    
    private var postsListener: Listener?
    private var explorePostsRefreshFunction: (() -> Void)?
    private var homePostsRefreshFunction: (() -> Void)?
    
    private var userListListener: Listener?
    private var userListRefreshFunction: (() -> Void)?

    private var explorePosts = [GenericPost]()
    private var homePosts = [GenericPost]()
    private var userList = [GenericUser]()

    private func clearAllData() {
        user = nil
        databaseUser = nil
        userListener?.registration.remove()
        userListener = nil
        userRefreshFunction = nil
        
        postsListener?.registration.remove()
        postsListener = nil
        explorePostsRefreshFunction = nil
        homePostsRefreshFunction = nil
        
        userListListener?.registration.remove()
        userListListener = nil
        userListRefreshFunction = nil
        
        explorePosts.removeAll()
        homePosts.removeAll()
        userList.removeAll()
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
                self.startListeners()
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
                self.startListeners()
                onComplete()
            })
        }
    }
    
    func startListeners() {
        if let userId = user?.uid {
            self.startUserListener(id: userId)
            self.startPostsListener()
            self.startUserListListener()
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
    
    // MARK: - Post Listener Functions
    public func getExplorePosts() -> [GenericPost] {
        return explorePosts
    }
    
    public func getHomePosts() -> [GenericPost] {
        return homePosts
    }
    
    private func startPostsListener() {
        postsListener?.registration.remove()
        explorePosts.removeAll()
        homePosts.removeAll()
        postsListener = Database.shared.allPostsListener(listenerId: "explorePosts", onComplete: postsListenerRead(add:remove:change:id:))
    }
    
    public func setExplorePostsRefreshFunction(with function: (() -> Void)?) {
        explorePostsRefreshFunction = function
    }
    
    public func setHomePostsRefreshFunction(with function: (() -> Void)?) {
        homePostsRefreshFunction = function
    }
    
    private func postsListenerRead(add: [GenericPost], remove: [String], change: [GenericPost], id: String) {
        guard let user = databaseUser else { return }
        let following = user.getFollowersSet()

        
        var addHome = [GenericPost]()
        var addExplore = [GenericPost]()
        
        var removeHome = [String]()
        var removeExplore = [String]()
        
        var changeHome = [GenericPost]()
        var changeExplore = [GenericPost]()
        
        for post in add {
            if following != nil && following!.contains(post.userId) {
                // I am following the user who posted this -> home
                addHome.append(post)
            } else if post.userId != user.id {
                addExplore.append(post)
            }
        }
        
        for post in change {
            if following != nil && following!.contains(post.userId) {
                changeHome.append(post)
            } else if post.userId != user.id {
                changeExplore.append(post)
            }
        }
        
        for postId in remove {
            if following != nil && following!.contains(postId) {
                removeHome.append(postId)
            } else {
                removeExplore.append(postId)
            }
        }
        handleHomePosts(add: addHome, remove: removeHome, change: changeHome, id: id)
        handleExplorePosts(add: addExplore, remove: removeExplore, change: changeHome, id: id)
    }
    
    private func handleHomePosts(add: [GenericPost], remove: [String], change: [GenericPost], id: String) {
        //add
        for post in add {
            self.homePosts.append(post)
        }
        //remove
        for id in remove {
            self.homePosts.removeAll(where: {$0.id == id})
        }
        //change
        for post in change {
            for i in 0..<self.homePosts.count where self.homePosts[i].id ==
                post.id {
                    self.homePosts[i].update(with: post)
            }
        }
//        explorePostsRefreshFunction?()
    }
    
    private func handleExplorePosts(add: [GenericPost], remove: [String], change: [GenericPost], id: String) {
        //add
        for post in add {
            self.explorePosts.append(post)
        }
        //remove
        for id in remove {
            self.explorePosts.removeAll(where: {$0.id == id})
        }
        //change
        for post in change {
            for i in 0..<self.explorePosts.count where self.explorePosts[i].id ==
                post.id {
                    self.explorePosts[i].update(with: post)
            }
        }
        explorePostsRefreshFunction?()
    }
    
    // MARK: - UserList function
    public func getUserList() -> [GenericUser] {
        return userList
    }
    
    public func setUserListRefreshFunction(with function: (() -> Void)?) {
        userListRefreshFunction = function
    }
    
    private func startUserListListener() {
        userListListener?.registration.remove()
        userList.removeAll()
        userListListener = Database.shared.allUsersListener(listenerId: "allUsers", onComplete: userListListenerRead)
    }
    
    private func userListListenerRead(add: [GenericUser], remove: [String], change: [GenericUser], id: String) {
        let userId = user?.uid ?? ""
        
        //add
        for userObj in add where userObj.id != userId {
            self.userList.append(userObj)
        }
        //remove
        for objId in remove where objId != userId {
            self.userList.removeAll(where: {$0.id == objId})
        }
        //change
        for userObj in change where userObj.id != userId {
            for i in 0..<self.userList.count where self.userList[i].id ==
                userObj.id {
                    self.userList[i].update(with: userObj)
            }
        }
        userListRefreshFunction?()
    }

}
