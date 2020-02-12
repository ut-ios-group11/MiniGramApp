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
    private var databaseUser: DatabaseUser?
    
    private init () {
    }
    
    private func clearAllData() {
        user = nil
        databaseUser = nil
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
        Fire.shared.read(at: query, returning: DatabaseUser.self, onError: onError, onComplete: { (databaseUser) in
            guard let databaseUser = databaseUser else {
                onError(UserDataError.couldNotLoadUser)
                return
            }
            self.databaseUser = databaseUser
            onComplete()
        })
    }
    
}
