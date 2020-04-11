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
    var image: UIImage?
    
    var posts = [GenericPost]()
    var minis = [GenericMini]()
    
    private var postsRefreshFunction: (() -> Void)?
    private var minisRefreshFunction: (() -> Void)?
    
    private var listeners = [Listener]()
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        name = doc.get("name") as? String
        followers = doc.get("followers") as? [String]
    }
    
    init(id: String, name: String, followers: [String]?, image: UIImage?) {
        self.id = id
        self.name = name
        self.followers = followers
        self.image = image
    }
    
    
    // MARK: - Listener Functions
    
    func setPostsRefreshFunction(refreshFunction: (() -> Void)?) {
        postsRefreshFunction = refreshFunction
    }
    
    func setMinisRefreshFunction(refreshFunction: (() -> Void)?) {
        minisRefreshFunction = refreshFunction
    }
    
    func startPostsListening() {
        for listener in listeners where listener.id == "Post" {
            listener.registration.remove()
        }
        
        listeners.removeAll { (listener) -> Bool in
            listener.id == "Post"
        }
        
        posts.removeAll()
        listeners.append(Database.shared
            .profilePostsListener(listenerId: "Post", userId: id, onComplete: postsListener))
    }
    
    func startMiniatureListening() {
        // Could be optimized
        for listener in listeners where listener.id == "Mini" {
            listener.registration.remove()
        }
        listeners.removeAll { (listener) -> Bool in
            listener.id == "Mini"
        }
        minis.removeAll()
        listeners.append(Database.shared.profileMiniaturesListener(listenerId: "Mini", userId: id, onComplete: minaturesListener))
    }
    
    private func postsListener(add: [GenericPost], remove: [String], change: [GenericPost], id: String) {
        //add
        for post in add {
            self.posts.append(post)
        }
        //remove
        for id in remove {
            self.posts.removeAll(where: {$0.id == id})
        }
        //change
        for post in change {
            for i in 0..<self.posts.count where self.posts[i].id ==
                post.id {
                    self.posts[i] = post
            }
        }
        print("Posts Listener Called")
        print("add:", add)
        print("remove:", remove)
        print("change:", change)
        postsRefreshFunction?()
    }
    
    private func minaturesListener(add: [GenericMini], remove: [String], change: [GenericMini], id: String) {
        //add
        for mini in add {
           self.minis.append(mini)
        }
        //remove
        for id in remove {
           self.minis.removeAll(where: {$0.id == id})
        }
        //change
        for mini in change {
           for i in 0..<self.minis.count where self.minis[i].id == mini.id {
               self.minis[i] = mini
           }
        }
        print("Minatures Listener Called")
        print("add:", add)
        print("remove:", remove)
        print("change:", change)
        minisRefreshFunction?()
    }
    
    
}
