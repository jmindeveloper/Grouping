//
//  EmailSignInView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

struct EmailSignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            VStack {
                EmailTextField(text: $email, type: .Email)
                    .placeHolder("이메일")
                
                EmailTextField(text: $password, type: .Password)
                    .secureMode(true)
                    .placeHolder("비밀번호")
            }
            .padding(.top, 45)
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                
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
        EmailSignInView()
    }
}
