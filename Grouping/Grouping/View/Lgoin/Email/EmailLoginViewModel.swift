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
    
    func signIn()
    func signUp()
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
    
    func signIn() {
        loginManager.signIn(email: email, password: password) {
            print("로그인 성공!!!!")
        }
    }
    
    func signUp() {
        loginManager.signUp(email: email, password: password) {
            print("회원가입 성공!!!!")
        }
    }
}
