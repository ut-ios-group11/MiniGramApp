//
//  FireAuth.swift
//  MiniGramApp
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseMessaging

class FireAuth {
    private init() {}
    static let shared = FireAuth()
    
    let db = Firestore.firestore()
    
    enum AuthError: Error {
        case AccountAlreadyExists
        case MissingUserError
        case SignInError
        case SignOutError
    }
    
    func isUserSignedIn() -> User? {
        return Auth.auth().currentUser
    }
    
    // MARK: Create User
    func createUser(email: String, password: String, onError: @escaping (Error) -> Void, onComplete: @escaping (User) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                onError(error)
            }
            guard let result = result else {
                onError(AuthError.AccountAlreadyExists)
                return
            }
            onComplete(result.user)
        }
    }
    
    // MARK: Delete User
    func deleteUser(password: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        guard let email = UserData.shared.getUserEmail() else {
            onError(AuthError.MissingUserError)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        if let currentUser = Auth.auth().currentUser {
            currentUser.reauthenticate(with: credential) { (authResult, error) in
                if let error = error {
                    onError(error)
                } else {
                    currentUser.delete
                        { error in
                        if let error = error {
                            onError(error)
                        } else {
                            onComplete()
                        }
                    }
                }
            }
        } else {
            onError(AuthError.MissingUserError)
        }
    }
    
    // MARK: Sign In/Out Methods
    func signIn(login: String, pass: String, onError: @escaping (Error) -> Void, onComplete: @escaping (User) -> Void) {
        Auth.auth().signIn(withEmail: login, password: pass) { (result, error) in
            guard error == nil else {
                onError(error!)
                return
            }
            guard let user = result?.user else {
                onError(AuthError.MissingUserError)
                return
            }
            self.updateFCMToken(at: FireCollection.Users, userId: user.uid)
            onComplete(user)
        }
    }
    
    func signOut(onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        // Additional stuff before sign out like removing FCM tokens
        if let token = Messaging.messaging().fcmToken, let userID = Auth.auth().currentUser?.uid {
            self.removeFCMToken(at: .Users, userID: userID, token: token)
        }
        signOutHelper(onError: onError, onComplete: onComplete)
    }
    
    func signOutHelper(onError: ((Error) -> Void)? = nil, onComplete: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            onComplete()
        } catch {
            onError?(error)
        }
    }
    
    // MARK: FCM Token Methods
    func updateFCMToken(at ref: FireCollection, userId: String, onError: ((Error) -> Void)? = nil, onComplete: (() -> Void)? = nil) {
        if Messaging.messaging().fcmToken != nil {
            let update = [
                "fcmTokens": FieldValue.arrayUnion([Messaging.messaging().fcmToken!]),
                "lastSignIn": Timestamp()
            ]
            let id = userId
            Fire.shared.update(at: db.collection(ref.rawValue).document(id), data: update, onError: { error in
                LogManager.logError(error)
                onError?(error)
            }, onComplete: {
                onComplete?()
            })
        }

    }

    func removeFCMToken(at ref: FireCollection, userID: String, token: String, onError: ((Error) -> Void)? = nil, onComplete: (() -> Void)? = nil) {
        let update = [
            "fcmTokens": FieldValue.arrayRemove([token])
        ]
        let id = userID
        Fire.shared.update(at: db.collection(ref.rawValue).document(id), data: update, onError: { (error) in
            LogManager.logError(error)
            onError?(error)
        }, onComplete: {
            onComplete?()
        })
    }
    
    func updateEmail(newEmail: String, password: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        guard let email = UserData.shared.getUserEmail() else {
            onError(AuthError.MissingUserError)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        if let currentUser = Auth.auth().currentUser {
            currentUser.reauthenticate(with: credential) { (authResult, error) in
                if let error = error {
                    onError(error)
                } else {
                    currentUser.updateEmail(to: newEmail) { (error) in
                        if let error = error {
                            onError(error)
                        } else {
                            onComplete()
                        }
                    }
                }
            }
        } else {
            onError(AuthError.MissingUserError)
        }
    }
    
    func updatePassword(oldPassword: String, newPassword: String, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        guard let email = UserData.shared.getUserEmail() else {
            onError(AuthError.MissingUserError)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        
        if let currentUser = Auth.auth().currentUser {
            currentUser.reauthenticate(with: credential) { (authResult, error) in
                if let error = error {
                    onError(error)
                } else {
                    currentUser.updatePassword(to: newPassword) { (error) in
                        if let error = error {
                            onError(error)
                        } else {
                            onComplete()
                        }
                    }
                }
            }
        } else {
            onError(AuthError.MissingUserError)
        }
    }
    
    
}
