//
//  EmailSignInView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

struct EmailSignInView<VM>: View where VM: EmailLoginViewModelInterface {
    @ObservedObject var viewModel: VM
    
    var body: some View {
        VStack {
            VStack {
                EmailTextField(text: $viewModel.email, type: .Email)
                    .placeHolder("이메일")
                
                EmailTextField(text: $viewModel.password, type: .Password)
                    .secureMode(true)
                    .placeHolder("비밀번호")
            }
            .padding(.top, 45)
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                viewModel.signIn()
            } label: {
                Text("로그인")
            }
            .padding(.bottom, 10)
        }
        .navigationTitle("이메일 로그인")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmailSignInView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignInView(viewModel: EmailLoginViewModel(type: .SignIn))
    }
}
