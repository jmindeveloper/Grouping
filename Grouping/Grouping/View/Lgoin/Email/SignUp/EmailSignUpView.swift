//
//  EmailSignUpView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/11.
//

import SwiftUI

struct EmailSignUpView<VM>: View where VM: EmailLoginViewModelInterface {
    
    @ObservedObject var viewModel: VM
    
    var body: some View {
        VStack {
            VStack {
                EmailTextField(text: $viewModel.email, type: .Email)
                    .placeHolder("이메일")
                
                EmailTextField(text: $viewModel.password, type: .Password)
                    .secureMode(true)
                    .placeHolder("비밀번호")
                
                EmailTextField(text: $viewModel.checkPassword, type: .Password)
                    .secureMode(true)
                    .placeHolder("비밀번호 확인")
            }
            .padding(.top, 45)
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                viewModel.signUp()
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
