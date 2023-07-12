//
//  EmailSignInView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

struct EmailSignInView<VM>: View where VM: EmailLoginViewModelInterface {
    @ObservedObject var viewModel: VM
    @State var emailCaption: Bool = false
    @State var passwordCaption: Bool = false
    @State var showWrongAlert: Bool = false
    
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
            }
            .padding(.top, 45)
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                emailCaption = false
                passwordCaption = false
                
                do {
                    try viewModel.signIn { isSuccess in
                        if isSuccess {
                            Constant.rootVC?.dismiss(animated: true)
                        } else {
                            showWrongAlert = true
                        }
                    }
                } catch {
                    let error = error as! EmailLoginError
                    switch error {
                    case .EmailMissmatch:
                        emailCaption = true
                    case .PasswordMismatch:
                        passwordCaption = true
                    default:
                        break
                    }
                }
            } label: {
                Text("로그인")
            }
            .padding(.bottom, 10)
        }
        .alert(isPresented: $showWrongAlert) {
            Alert(title: Text(""), message: Text("이메일 또는 비밀번호가 잘못됐습니다"), dismissButton: .default(Text("확인")))
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
