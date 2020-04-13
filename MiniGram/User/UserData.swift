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

    // Only For Alpha
    public var explorePosts = [GenericPost]()
    public var exploreUsers = [GenericUser]()

    public var galleryPosts = [GenericPost]()
    public var miniPosts = [GenericMini]()

    private init () {
        //For Testing Only
        createTestData()
    }

    private func clearAllData() {
        user = nil
        databaseUser = nil
    }

    public func getDatabaseUser() -> GenericUser? {
        return self.databaseUser
    }

    public func signOut(onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        FireAuth.shared.signOut(onError: onError) {
            self.clearAllData()
            onComplete()
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

    public func tryAutoSignIn(onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        if let user = FireAuth.shared.isUserSignedIn() {
            readUser(id: user.uid, onError: onError, onComplete: onComplete)
        } else {
            onError(UserDataError.noSignedInUser)
        }
    }

    private func signInHelper(email: String, password: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        FireAuth.shared.signIn(login: email, pass: password, onError: onError) { (user) in
            self.user = user
            self.readUser(id: user.uid, onError: onError, onComplete: onComplete)
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
            databaseUser.startPostsListening()
            databaseUser.startMiniatureListening()
            onComplete()
        })
    }


    // MARK: TEST DATA
    private func createTestData() {
        // Explore Posts
        for i in 0...10 {
            let newPost = GenericPost(id: "\(i)", userId: "\(i)", likes: ["user1", "user2", "user3"], desc: "lorem ipsum something something something. #something", date: Timestamp(), image: UIImage(named: "minature\(Int.random(in: 0 ..< 3))"))
            for j in 0...2 {
                let comment = Comment(id: "\(j)", userId: "\(i)", message: "this is a comment. Specifically comment number \(j) created by user \(i)", date: Timestamp())
                newPost.addComment(comment: comment)
            }
            explorePosts.append(newPost)
        }

        // Explore Users
        for i in 0...10 {
            let newUser = GenericUser(id: "\(i)", name: "User\(i)", followers: nil, image: UIImage(systemName: "person.circle.fill"))
            exploreUsers.append(newUser)
        }
        // Gallery Posts
        for i in 0...10 {
            let newPost = GenericPost(id: "\(i)", userId: "\(i)", likes: ["user1", "user2", "user3"], desc: "lorem ipsum something something something. #something", date: Timestamp(), image: UIImage(named: "minature\(Int.random(in: 0 ..< 3))"))
            galleryPosts.append(newPost)
        }
        
        for i in 0...10 {            
            let newMini = GenericMini(id: "\(i)", userId: "\(i)", date: Timestamp(), unit: "Test Unit", name: "Test Name", image: UIImage(named: "minature\(Int.random(in: 0 ..< 3))")!, pointValue: 0, power: 0, movement: 0, weaponSkill: 0, ballisticSkill: 0, strength: 0, toughness: 0, wounds: 0, attacks: 0, leadership: 0, save: 0, weapons: ["Weapon1", "Weapon2", "Weapon3"], warGear: ["Wargear1", "Wargear2", "Wargear3"], abilities: ["Ability1", "Ability2"], factionKeywords: ["fk1", "fk2"], keywords: ["key1", "key2", "key3"])
            miniPosts.append(newMini)
        }
    }
}
