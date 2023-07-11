//
//  LoginMainView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

struct LoginMainView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .bottom, spacing: 0) {
                    Text("회원가입하고 ")
                        .font(.system(size: 20))
                    Text("Grouping")
                        .font(.system(size: 27, weight: .bold, design: .monospaced))
                        .foregroundColor(.red)
                    Text(" 이용하기")
                        .font(.system(size: 20))
                }
                .padding(.top, 45)
                
                Spacer()
                
                loginButtonStackView()
                
                Spacer()
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func loginButtonStackView() -> some View {
        VStack(spacing: 8) {
            Button {
                
            } label: {
                LoginButton(title: "구글로 로그인하기", imageName: "test_image_1", backgroundColor: .white)
                    .border(true)
                    .foregroundColor(.black)
            }
            .buttonStyle(.plain)
            
            Button {
                
            } label: {
                LoginButton(title: "애플로 로그인하기", imageName: "test_image_5", backgroundColor: .black)
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
            
            HStack {
                NavigationLink {
                    EmailSignInView()
                } label: {
                    Text("이메일로 로그인")
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
                
                Divider()
                    .frame(height: 17)
                    .padding(.horizontal, 3)
                
                NavigationLink {
                    EmailSignUpView(viewModel: EmailLoginViewModel(type: .SignUp))
                } label: {
                    Text("이메일로 회원가입")
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 7)
        }
        .padding(.horizontal, 16)
    }
}

struct LoginMainView_Previews: PreviewProvider {
    static var previews: some View {
        LoginMainView()
    }
}
