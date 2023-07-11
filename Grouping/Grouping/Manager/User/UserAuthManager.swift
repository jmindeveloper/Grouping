//
//  UserAuthManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/12.
//

import Foundation
import FirebaseFirestore

final class UserAuthManager {
    
    static let shared = UserAuthManager()
    let db = Firestore.firestore().collection("Users")
    
    private init() { }
    
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
    
}

