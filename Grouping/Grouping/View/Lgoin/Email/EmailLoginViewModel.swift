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
    
    func signIn(completion: ((_ isSuccess: Bool) -> Void)?) throws
    func signUp(completion: ((Result<Bool, EmailLoginError>) -> Void)?) throws
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
    
    func signIn(completion: ((_ isSuccess: Bool) -> Void)? = nil) throws {
        if !validateEmail() {
            throw EmailLoginError.EmailMissmatch
        }
        if !validatePassword() {
            throw EmailLoginError.PasswordMismatch
        }
        loginManager.signIn(email: email, password: password) { id in
            UserAuthManager.shared.getUser() { isSuccess in
                if isSuccess {
                    print("로그인 성공")
                }
                completion?(isSuccess)
            }
        }
    }
    
    func signUp(completion: ((Result<Bool, EmailLoginError>) -> Void)? = nil) throws {
        if !validateEmail() {
            throw EmailLoginError.EmailMissmatch
        }
        if !validatePassword() {
            throw EmailLoginError.PasswordMismatch
        }
        if !validateCheckPassword() {
            throw EmailLoginError.CheckPasswordMismatch
        }
        loginManager.checkEmailExist(email: email) { [weak self] isExist in
            guard let self = self else { return }
            if !isExist {
                self.loginManager.signUp(email: self.email, password: self.password) {
                    let user = UserAuthManager.shared.createUser(id: $0, email: self.email)
                    UserAuthManager.shared.uploadUser(user: user) {
                        print("User 업로드 성공")
                        completion?(.success(true))
                    }
                }
            } else {
                completion?(.failure(.EmailAlreadyExist))
            }
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
