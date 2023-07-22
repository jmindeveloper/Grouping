//
//  GroupListCell.swift
//  Grouping
//
//  Created by J_Min on 2023/07/22.
//

import SwiftUI

struct ProfileGroupCell: View {
    @State var group: Group
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(group.groupName)
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                }
                HStack {
                    Text(group.groupDescription)
                        .font(.system(size: 13))
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.top, 8)
                
            }
            .padding(.leading, 16)
            .padding(.vertical, 3)
            
            Image(systemName: "chevron.right")
                .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .background(Color.random)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ProfileGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        ProfileGroupCell(group: Group(groupId: "", groupName: "dummyGroup", groupDescription: "더미 그룹입니다ㅠㅠ", posts: [], createUserId: "", managementUsers: [], shareMembers: [], startUsers: [], approvalWaitingUsers: []))
//            .padding(.horizontal, 16)
            .previewLayout(.sizeThatFits)
    }
}