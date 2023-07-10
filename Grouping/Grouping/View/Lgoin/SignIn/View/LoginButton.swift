//
//  LoginButton.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

struct LoginButton: View {
    var backgroundColor: Color
    var imageName: String?
    var title: String
    
    var body: some View {
        ZStack {
            HStack {
                if let name = imageName {
                    Image(name)
                        .resizable()
                        .frame(width: 45, height: 45)
                        .scaledToFill()
                        .clipShape(Circle())
                        .padding(.leading, 16)
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Text(title)
                    .fontWeight(.semibold)
                
                Spacer()
            }
        }
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
        )
    }
    
    func backgroundColor(_ color: Color) -> LoginButton {
        LoginButton(backgroundColor: color, imageName: imageName, title: title)
    }
    
    func title(_ title: String) -> LoginButton {
        LoginButton(backgroundColor: backgroundColor, imageName: imageName, title: title)
    }
    
    func image(_ imageName: String?) -> LoginButton {
        LoginButton(backgroundColor: backgroundColor, imageName: imageName, title: title)
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton(backgroundColor: Color(uc: .clear), imageName: "test_image", title: "구글로 로그인하기")
            .backgroundColor(.red)
            .previewLayout(.sizeThatFits)
            .frame(width: Constant.screenWidth - 32, height: 56)
    }
}
