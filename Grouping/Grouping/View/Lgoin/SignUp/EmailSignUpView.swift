//
//  EmailSignUpView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/11.
//

import SwiftUI

struct EmailSignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var checkPassword: String = ""
    
    var body: some View {
        VStack {
            VStack {
                EmailTextField(text: $email, type: .Email)
                    .placeHolder("이메일")
                
                EmailTextField(text: $password, type: .Password)
                    .secureMode(true)
                    .placeHolder("비밀번호")
                
                EmailTextField(text: $checkPassword, type: .Password)
                    .secureMode(true)
                    .placeHolder("비밀번호 확인")
            }
            .padding(.top, 45)
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                
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
        EmailSignUpView()
    }
}
