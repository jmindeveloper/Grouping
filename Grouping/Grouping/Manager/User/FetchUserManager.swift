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
    var starPostIds: [String] { get set }
    var starGroupIds: [String] { get set }
    
    func getUser(userId: String, completion: ((_ user: User) -> Void)?)
    func getUserSimpleInfo(userId: String, completion: ((_ user: UserSimpleInfo) -> Void)?)
    func getStartPosts(userId: String, completion: ((_ postIds: [String]) -> Void)?)
    func getStartGroups(userId: String, completion: ((_ groupIds: [String]) -> Void)?)
    func updateUserStartPost(completion: ((_ ids: [String]) -> Void)?)
}

final class FetchUserManager: FetchUserManagerInterface {
    let userDB = Firestore.firestore().collection(FBFieldName.users)
    var starPostIds: [String] = []
    var starGroupIds: [String] = []
    var userId: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    /// 현재 로그인 한 유저만 사용
    static let `default`: FetchUserManagerInterface = FetchUserManager()
    
    private init() {
        NotificationCenter.default.publisher(for: .userLogin)
            .sink { [weak self] _ in
                guard let user = UserAuthManager.shared.user else {
                    return
                }
                self?.userId = user.id
                self?.getStartPosts(userId: user.id) { posts in
                    self?.starPostIds = posts
                }
                
                self?.getStartGroups(userId: user.id) { group in
                    self?.starGroupIds = group
                }
            }.store(in: &subscriptions)
    }
    
    init(userId: String) {
        self.userId = userId
        getStartPosts(userId: userId) { [weak self] posts in
            self?.starPostIds = posts
        }
        
        getStartGroups(userId: userId) { [weak self] group in
            self?.starGroupIds = group
        }
    }
    
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
    
    func updateUserStartPost(completion: ((_ ids: [String]) -> Void)? = nil) {
        userDB.document(userId)
            .collection(FBFieldName.starPost)
            .document(FBFieldName.starPost)
            .setData([FBFieldName.userStarPost: starPostIds]) { [weak self] error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                guard let self = self else { return }
                completion?(self.starPostIds)
            }
    }
}
