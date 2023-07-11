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
}

final class EmailLoginManager {
    private let auth = Auth.auth()
    
    func signUp(email: String, password: String, completion: (() -> Void)? = nil) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                return
            }
            completion?()
        }
    }
    
    func signIn(email: String, password: String, completion: (() -> Void)? = nil) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                return
            }
            completion?()
        }
    }
}
