//
//  FollowManagementManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/12.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FollowManagementManagerInterface {
    func follow(subjectUser: User, completion: (() -> Void)?)
    func deleteFollow(subjectId: String, completion: (() -> Void)?)
}

final class FollowManagementManager: FollowManagementManagerInterface {
    private var user: User? {
        UserAuthManager.shared.user
    }
    private let db = Firestore.firestore().collection(FBFieldName.users)
    
    func follow(subjectUser: User, completion: (() -> Void)? = nil) {
        followUpdate(subjectId: subjectUser.id) { [weak self] in
            self?.followingUpdate(subjectUser: subjectUser) {
                completion?()
            }
        }
    }
    
    func deleteFollow(subjectId: String, completion: (() -> Void)?) {
        
    }
    
    private func followUpdate(subjectId: String, completion: (() -> Void)? = nil) {
        guard let user = user else {
            return
        }
        
        if let index = user.followers.firstIndex(of: subjectId) {
            user.followers.remove(at: index)
        } else {
            user.followers.append(subjectId)
        }
        
        db.document(user.id).updateData([FBFieldName.followers: user.followers]) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            completion?()
        }
    }
    
    private func followingUpdate(subjectUser: User, completion: (() -> Void)? = nil) {
        guard let user = user else {
            return
        }
        
        if let index = subjectUser.following.firstIndex(of: user.id) {
            subjectUser.following.remove(at: index)
        } else {
            subjectUser.following.append(user.id)
        }
        
        db.document(subjectUser.id).updateData([FBFieldName.following: subjectUser.following]) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            completion?()
        }
    }
    
}
