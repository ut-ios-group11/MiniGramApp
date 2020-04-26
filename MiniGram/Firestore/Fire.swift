//
//  Fire.swift
//  MiniGram
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

/*
 Standard interface for interacting with firestore
*/

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging

class Fire {
    private init() {}
    static let shared = Fire()
    
    enum BatchOperation {
        case update
        case set
        case delete
    }
    
    struct Operation {
        var type: BatchOperation
        var data: [String: Any]?
        var ref: DocumentReference
    }
    
    enum FireError: Error {
        case emptyReturn
        case ImageCompressionError
        case ImageConversionError
    }
    
    func arrayUnion<T>(data: [T]) -> FieldValue {
        return FieldValue.arrayUnion(data)
    }
    
    func arrayRemove<T>(data: [T]) -> FieldValue {
        return FieldValue.arrayRemove(data)
    }
    
    func create(at ref: CollectionReference, withID: String = "", data: [String: Any], onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        var objData = data
        objData["deleted"] = false
        
        if !withID.isEmpty {
            ref.document(withID).setData(data) { error in
                if let error = error {
                    LogManager.logError(error)
                    onError(error)
                }
                onComplete()
            }
        } else {
            ref.addDocument(data: objData) { error in
                if let error = error {
                    LogManager.logError(error)
                    onError(error)
                }
                onComplete()
            }
        }
    }
    
    func uploadImage(at ref: FireStorageCollection, id: String, image: UIImage, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            onError(FireError.ImageCompressionError)
            return
        }
        
        let storageRef = Storage.storage().reference().child(ref.rawValue).child(id + ".jpeg")
        
        storageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                LogManager.logError(error)
                onError(error)
            }
            onComplete()
        }
    }
    
    func downloadImage(at ref: FireStorageCollection, id: String, OnError: @escaping (Error) -> Void, onComplete: @escaping (UIImage) -> Void) {
        let storageRef = Storage.storage().reference().child(ref.rawValue).child(id + ".jpeg")
        
        storageRef.getData(maxSize: 1*1024*1024) { (data, error) in
            if let error = error {
                LogManager.logError(error)
                OnError(error)
            }
            guard let data = data else {
                LogManager.logError(FireError.emptyReturn)
                OnError(FireError.emptyReturn)
                return
            }
            guard let image = UIImage(data: data) else {
                LogManager.logError(FireError.ImageConversionError)
                OnError(FireError.ImageConversionError)
                return
            }
            onComplete(image)
        }
    }
    
    func doesDocExist(at ref: DocumentReference, onError: @escaping (Error) -> Void, onComplete: @escaping (Bool) -> Void) {
        ref.getDocument { (snapshot, error) in
            if let error = error {
                LogManager.logError(error)
                onError(error)
            } else {
                if snapshot!.exists && snapshot?.get("deleted") as? Bool ?? false == false {
                    onComplete(true)
                } else {
                    onComplete(false)
                }
            }
        }
    }
    
    func read<T: FireInitable>(at ref: Query, returning type: T.Type, onError: @escaping ((Error) -> Void), onComplete: @escaping ([T]?) -> Void) {
        
        var query = ref
        
        query = query.whereField("deleted", isEqualTo: false)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                LogManager.logError(error)
                onError(error)
            }
            var objects = [T]()
            for document in snapshot!.documents {
                objects.append(T.init(doc: document))
            }
            onComplete(objects)
        }
    }
    
    func read<T: FireInitable>(at ref: DocumentReference, returning type: T.Type, onError: @escaping ((Error) -> Void), onComplete: @escaping (T?) -> Void) {
        
        ref.getDocument { (snapshot, error) in
            if let error = error {
                LogManager.logError(error)
                onError(error)
            }
            guard let snapshot = snapshot else {
                onError(FireError.emptyReturn)
                return
            }
            onComplete(T(doc: snapshot))
        }
    }
    
    func listener<T: FireInitable>(at ref: DocumentReference, returning type: T.Type, onComplete: @escaping (T) -> Void) -> ListenerRegistration {
        let listenerReg = ref.addSnapshotListener { (snapshot, error) in
            if let error = error {
                LogManager.logError(error)
                return
            }
            guard let snapshot = snapshot else { return }
            onComplete(T.init(doc: snapshot))
        }
        return listenerReg
    }
    
    func listener<T: FireInitable>(at ref: Query, id: String = "", returning type: T.Type, onComplete: @escaping ([T], [String], [T], String) -> Void) -> ListenerRegistration {
        let listenerReg = ref.addSnapshotListener { (snapshot, error) in
            if let error = error {
                LogManager.logError(error)
                return
            }
            var addObjects = [T]()
            var removeObjects = [String]()
            var changeObjects = [T]()
            
            snapshot?.documentChanges.forEach({ (diff) in
                let deleted = diff.document.get("deleted") as? Bool ?? false
                if diff.type == .added {
                    if !deleted {
                        addObjects.append(T.init(doc: diff.document))
                    }
                } else if diff.type == .removed {
                    removeObjects.append(diff.document.documentID)
                } else if diff.type == .modified {
                    if deleted {
                        removeObjects.append(diff.document.documentID)
                    } else {
                        changeObjects.append(T.init(doc: diff.document))
                    }
                }
            })
            onComplete(addObjects, removeObjects, changeObjects, id)
        }
        return listenerReg
    }
    
    func update(at ref: DocumentReference, data: [String: Any], onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        ref.updateData(data) { (error) in
            if let error = error {
                LogManager.logError(error)
                onError(error)
            }
            onComplete()
        }
    }
    
    func batchUpdate(operations: [Operation], onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let batch = Firestore.firestore().batch()
        for operation in operations {
            switch operation.type {
            case .update:
                guard let data = operation.data else {break}
                batch.updateData(data, forDocument: operation.ref)
            case .delete:
                batch.deleteDocument(operation.ref)
            case .set:
                guard let data = operation.data else {break}
                batch.setData(data, forDocument: operation.ref)
            }
        }
        batch.commit { (error) in
            if let error = error {
                onError(error)
            } else {
                onComplete()
            }
        }
        
    }
    
    func deleteWithBool(at ref: DocumentReference, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let data = [
            "deleted": true
        ]
        ref.updateData(data) { (error) in
            if let error = error {
                LogManager.logError(error)
                onError(error)
            }
            onComplete()
        }
    }
    
    func delete(at ref: DocumentReference, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        ref.delete { (error) in
            if let error = error {
                LogManager.logError(error)
                onError(error)
            }
            onComplete()
        }
    }
    
}

struct Listener {
    var registration: ListenerRegistration
    var id: String
    
    init(id: String, registration: ListenerRegistration ) {
        self.registration = registration
        self.id = id
    }
}
