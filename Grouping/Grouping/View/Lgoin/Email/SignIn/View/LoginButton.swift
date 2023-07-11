//
//  LoginButton.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

struct LoginButton: View {
    private var backgroundColor: Color
    private var imageName: String?
    private var title: String
    private var border: Bool
    
    private init(title: String, imageName: String?, backgroundColor: Color, border: Bool) {
        self.title = title
        self.imageName = imageName
        self.backgroundColor = backgroundColor
        self.border = border
    }
    
    init(title: String, imageName: String?, backgroundColor: Color) {
        self.init(title: title, imageName: imageName, backgroundColor: backgroundColor, border: false)
    }
    
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
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: border ? 0.3 : 0)
                )
        )
    }
    
    func backgroundColor(_ color: Color) -> LoginButton {
        LoginButton(title: title, imageName: imageName, backgroundColor: color, border: border)
    }
    
    func title(_ title: String) -> LoginButton {
        LoginButton(title: title, imageName: imageName, backgroundColor: backgroundColor, border: border)
    }
    
    func image(_ imageName: String?) -> LoginButton {
        LoginButton(title: title, imageName: imageName, backgroundColor: backgroundColor, border: border)
    }
    
    func border(_ isShow: Bool) -> LoginButton {
        LoginButton(title: title, imageName: imageName, backgroundColor: backgroundColor, border: isShow)
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton(title: "구글로 로그인하기", imageName: "test_image", backgroundColor: .white)
//            .backgroundColor(.red)
            .border(true)
            .previewLayout(.sizeThatFits)
            .frame(width: Constant.screenWidth - 32, height: 56)
    }
}
