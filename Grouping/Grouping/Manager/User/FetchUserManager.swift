//
//  FetchUserManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/20.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FetchUserManagerInterface {
    func getUser(userId: String, completion: ((_ user: User) -> Void)?)
    func getUserSimpleInfo(userId: String, completion: ((_ user: UserSimpleInfo) -> Void)?)
    func getStartPosts(userId: String, completion: ((_ postIds: [String]) -> Void)?)
    func getStartGroups(userId: String, completion: ((_ groupIds: [String]) -> Void)?)
}

final class FetchUserManager: FetchUserManagerInterface {
    let userDB = Firestore.firestore().collection(FBFieldName.users)
    
    func getUser(userId: String, completion: ((_ user: User) -> Void)? = nil) {
        userDB.document(userId).getDocument { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            do {
                guard let user = try snapshot?.data(as: User.self) else {
                    return
                }
                completion?(user)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserSimpleInfo(userId: String, completion: ((_ user: UserSimpleInfo) -> Void)? = nil) {
        userDB.document(userId).getDocument { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            do {
                guard let user = try snapshot?.data(as: UserSimpleInfo.self) else {
                    return
                }
                completion?(user)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getStartPosts(userId: String, completion: ((_ postIds: [String]) -> Void)? = nil) {
        userDB.document(userId)
            .collection(FBFieldName.starPost)
            .document(FBFieldName.starPost).getDocument { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                guard let data = snapshot?.data(),
                      let starPosts = data[FBFieldName.userStarPost] as? [String] else {
                    return
                }
                completion?(starPosts)
            }
    }
    
    func getStartGroups(userId: String, completion: ((_ groupIds: [String]) -> Void)? = nil) {
        userDB.document(userId)
            .collection(FBFieldName.starGroup)
            .document(FBFieldName.starGroup).getDocument { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                guard let data = snapshot?.data(),
                      let starPosts = data[FBFieldName.userStarGroup] as? [String] else {
                    return
                }
                completion?(starPosts)
            }
    }
}
