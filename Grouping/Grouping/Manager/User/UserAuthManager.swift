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
    private let db = Firestore.firestore().collection("Users")
    var user: User?
    
    private init() { }
    
    var getCurrentUserId: String? {
        auth.currentUser?.uid
    }
    
    func createUser(id: String) -> User {
        return User(
            id: id,
            nickName: UUID().uuidString,
            profileImagePath: nil,
            birthDay: nil,
            phoneNumber: nil,
            gender: nil,
            followersCount: 0,
            followingCount: 0
        )
    }
    
    func uploadUser(user: User, completion: (() -> Void)? = nil) {
        do {
            try db.document(user.id).setData(from: user) { [weak self] error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self?.user = user
                completion?()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getUser(id: String, completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        
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
}

