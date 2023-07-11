//
//  EmailSignUpView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/11.
//

import SwiftUI

struct EmailSignUpView<VM>: View where VM: EmailLoginViewModelInterface {
    @ObservedObject var viewModel: VM
    @State var emailCaption: Bool = false
    @State var passwordCaption: Bool = false
    @State var checkPasswordCaption: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                EmailTextField(text: $viewModel.email, type: .Email, caption: "이메일이 올바르지 않습니다")
                    .placeHolder("이메일")
                    .caption(emailCaption)
                
                EmailTextField(text: $viewModel.password, type: .Password, caption: "비밀번호가 올바르지 않습니다")
                    .secureMode(true)
                    .placeHolder("비밀번호")
                    .caption(passwordCaption)
                
                EmailTextField(text: $viewModel.checkPassword, type: .Password, caption: "비밀번호가 일치하지 않습니다")
                    .secureMode(true)
                    .placeHolder("비밀번호 확인")
                    .caption(checkPasswordCaption)
            }
            .padding(.top, 45)
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                emailCaption = false
                passwordCaption = false
                checkPasswordCaption = false

                do {
                    try viewModel.signUp()
                } catch {
                    let error = error as! EmailLoginError
                    switch error {
                    case .EmailMissmatch:
                        emailCaption = true
                    case .PasswordMismatch:
                        passwordCaption = true
                    case .CheckPasswordMismatch:
                        checkPasswordCaption = true
                    }
                }
            } label: {
                Text("회원가입")
            }
            .padding(.bottom, 10)
        }
        .navigationTitle("이메일 회원가입")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmailSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignUpView(viewModel: EmailLoginViewModel(type: .SignUp))
    }
}
