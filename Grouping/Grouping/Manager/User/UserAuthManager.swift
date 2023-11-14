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
        let urlString = "https://asia-northeast3-grouping-3944d.cloudfunctions.net/groupingApp/api/users"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let body = try? JSONEncoder().encode(user) else {
            return
        }
        
        request.httpBody = body
        request.application_json()
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async { [weak self] in
                    self?.user = user
                    NotificationCenter.default.post(name: .userLogin, object: nil)
                    completion?()
                }
            }
        }.resume()
    }
    
    func updateUser(user: User, completion: (() -> Void)? = nil) {
        do {
            try db.document(user.id).setData(from: user) { [weak self] error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self?.user = user
                
                NotificationCenter.default.post(name: .userUpdate, object: nil)
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
                self?.bindingUserDocument(id: user.id)
                NotificationCenter.default.post(name: .userLogin, object: nil)
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
    
    func bindingUserDocument(id: String) {
        db.document(id).addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            do {
                guard let user = try snapshot?.data(as: User.self) else {
                    return
                }
                self?.user = user
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

