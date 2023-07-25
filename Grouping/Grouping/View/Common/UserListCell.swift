//
//  UserListCell.swift
//  Grouping
//
//  Created by J_Min on 2023/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserListCell: View {
    @State var user: User
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: user.profileImagePath ?? ""))
                .placeholder(Image(systemName: "person.fill").resizable())
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Text(user.nickName)
                .font(.system(size: 21, weight: .medium))
                .padding(.leading, 4)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

struct UserListCell_Previews: PreviewProvider {
    static var previews: some View {
        UserListCell(user: User(id: "asdf", nickName: "nickName", email: "dkldfj@kdasfj.com"))
    }
}
