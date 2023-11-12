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
}

final class FollowManagementManager: FollowManagementManagerInterface {
    private var user: User? {
        UserAuthManager.shared.user
    }
    private let db = Firestore.firestore().collection(FBFieldName.users)
    
    func follow(subjectUser: User, completion: (() -> Void)? = nil) {
        guard let user = user else {
            return
        }
        let baseURL = "https://asia-northeast3-grouping-3944d.cloudfunctions.net/groupingApp/api/users/follow?userId=\(user.id)&followId=\(subjectUser.id)"
        
        guard let url = URL(string: baseURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion?()
            }
        }.resume()
    }
}
