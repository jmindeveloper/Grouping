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
    func bookMark(post: Post, completion: ((_ post: Post) -> Void)?)
}

final class PostInteractionManager: PostInteractionManagerInterface {
    private let postDB = Firestore.firestore().collection(FBFieldName.post)
    private var fetchUserManager: FetchUserManagerInterface = FetchUserManager.default
    private let userFetchManager: FetchUserManagerInterface = FetchUserManager.default
    
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
    
    /// currentLoginUser의 startPosts에 post의 id 추가
    func bookMark(post: Post, completion: ((_ post: Post) -> Void)? = nil) {
        if let index = fetchUserManager.starPostIds.firstIndex(of: post.id) {
            fetchUserManager.starPostIds.remove(at: index)
            fetchUserManager.updateUserStartPost(completion: nil)
        } else {
            fetchUserManager.starPostIds.append(post.id)
            fetchUserManager.updateUserStartPost(completion: nil)
        }
    }
}
