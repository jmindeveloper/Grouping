//
//  UserAuthManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/12.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserAuthManager {
    
    static let shared = UserAuthManager()
    private let auth = Auth.auth()
    private let db = Firestore.firestore().collection(FBFieldName.users)
    var user: User?
    
    private init() { }
    
    /// 현재 로그인 돼있는 User의 아이디
    /// 현재 로그인 돼있지 않으면 nil
    var currentUserId: String? {
        auth.currentUser?.uid
    }
    
    /// 새로운 유저 생성
    func createUser(id: String, email: String) -> User {
        return User(
            id: id,
            nickName: UUID().uuidString,
            profileImagePath: nil,
            birthDay: nil,
            phoneNumber: nil,
            gender: nil,
            email: email
        )
    }
    
    /// 유저 업로드
    func uploadUser(user: User, completion: (() -> Void)? = nil) {
        do {
            try db.document(user.id).setData(from: user) { [weak self] error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self?.user = user
                
                self?.db.document(user.id).collection("Post").document("Post").setData(["posts": Array<String>()])
                self?.db.document(user.id).collection("Group").document("Group").setData(["groups": Array<String>()])
                self?.db.document(user.id).collection("StarPost").document("StarPost").setData(["starPosts": Array<String>()])
                self?.db.document(user.id).collection("StarGroup").document("StarGroup").setData(["starGroups": Array<String>()])
                
                completion?()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 유저 가져오기
    func getUser(completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        guard let id = currentUserId else {
            completion?(false)
            return
        }
        
        db.document(id).getDocument { [weak self] snap, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion?(false)
                return
            }
            
            do {
                guard let user = try snap?.data(as: User.self) else {
                    completion?(false)
                    return
                }
                
                self?.user = user
                completion?(true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// 로그아웃
    func logout(completion: (() -> Void)? = nil) {
        do {
            try auth.signOut()
            completion?()
        } catch {
            print(error.localizedDescription)
        }
    }
}

