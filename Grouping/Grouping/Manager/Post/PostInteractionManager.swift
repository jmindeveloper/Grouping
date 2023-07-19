//
//  PostInteractionManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import Foundation
import FirebaseFirestore

protocol PostInteractionManagerInterface {
    func heart(sender userId: String, post: Post, completion: ((_ post: Post) -> Void)?)
    func bookMark(sender userId: String, post: Post, completion: ((_ post: Post) -> Void)?)
}

final class PostInteractionManager: PostInteractionManagerInterface {
    private let postDB = Firestore.firestore().collection(FBFieldName.post)
    
    func heart(sender userId: String, post: Post, completion: ((_ post: Post) -> Void)? = nil) {
        var post = post
        if post.heartUsers.contains(userId) {
            post.heartUsers.removeAll { $0 == userId }
        } else {
            post.heartUsers.append(userId)
        }
        
        postDB.document(post.id).updateData(["heartUsers": post.heartUsers]) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            completion?(post)
        }
    }
    
    func bookMark(sender userId: String, post: Post, completion: ((_ post: Post) -> Void)? = nil) {
        
    }
}
