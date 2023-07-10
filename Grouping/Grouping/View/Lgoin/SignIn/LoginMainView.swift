//
//  LoginMainView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

struct LoginMainView: View {
    var body: some View {
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
        }
    }
}

struct LoginMainView_Previews: PreviewProvider {
    static var previews: some View {
        LoginMainView()
    }
}
