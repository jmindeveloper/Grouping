//
//  EmailLoginViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/11.
//

import Foundation

protocol EmailLoginViewModelInterface: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    var checkPassword: String { get set }
    
    init(type: EmailLoginViewModel.ViewModelType)
    
    func signIn() throws
    func signUp() throws
}

final class EmailLoginViewModel: EmailLoginViewModelInterface {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var checkPassword: String = ""
    
    enum ViewModelType {
        case SignIn, SignUp
    }
    
    private let type: ViewModelType
    private let loginManager = EmailLoginManager()
    
    init(type: ViewModelType) {
        self.type = type
    }
    
    func signIn() throws {
        if !validateEmail() {
            throw EmailLoginError.EmailMissmatch
        }
        if !validatePassword() {
            throw EmailLoginError.PasswordMismatch
        }
        loginManager.signIn(email: email, password: password) {
            print("로그인 성공!!!!")
        }
    }
    
    func signUp() throws {
        if !validateEmail() {
            throw EmailLoginError.EmailMissmatch
        }
        if !validatePassword() {
            throw EmailLoginError.PasswordMismatch
        }
        if !validateCheckPassword() {
            throw EmailLoginError.CheckPasswordMismatch
        }
        loginManager.signUp(email: email, password: password) {
            print("회원가입 성공!!!!")
        }
    }
    
    private func validateEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCondition = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return emailCondition.evaluate(with: email)
    }
    
    private func validatePassword() -> Bool {
        let valid = password.count >= 8
        
        return valid
    }
    
    private func validateCheckPassword() -> Bool {
        return password == checkPassword
    }
}
