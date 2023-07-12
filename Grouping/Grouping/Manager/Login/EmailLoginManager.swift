//
//  EmailLoginManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/11.
//

import Foundation
import FirebaseAuth

enum EmailLoginError: Error {
    case EmailMissmatch
    case PasswordMismatch
    case CheckPasswordMismatch
    case EmailAlreadyExist
}

final class EmailLoginManager {
    private let auth = Auth.auth()
    
    func signUp(email: String, password: String, completion: ((_ isSuccess: String) -> Void)? = nil) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                return
            }
            guard let result = result else {
                return
            }
            completion?(result.user.uid)
        }
    }
    
    func signIn(email: String, password: String, completion: ((_ id: String) -> Void)? = nil) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                return
            }
            guard let result = result else {
                return
            }
            completion?(result.user.uid)
        }
    }
    
    func checkEmailExist(email: String, completion: ((_ isExist: Bool) -> Void)? = nil) {
        auth.fetchSignInMethods(forEmail: email) { strs, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let strs = strs {
                if strs.isEmpty {
                    completion?(false)
                } else {
                    completion?(true)
                }
            } else {
                completion?(false)
            }
        }
    }
}
