//
//  GroupListCell.swift
//  Grouping
//
//  Created by J_Min on 2023/07/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GroupListCell: View {
    @State var group: Group
    private var groupSelectAction: ((Group) -> Void)?
    
    init(group: Group, groupSelectAction: ((Group) -> Void)? = nil) {
        self.groupSelectAction = groupSelectAction
        self._group = State(initialValue: group)
    }
    
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
                .padding(.top, 3)
                
            }
            .padding(.leading, 16)
            .padding(.vertical, 6)
            
            Image(systemName: "chevron.right")
                .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .background(
            WebImage(url: URL(string: group.groupThumbnailImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .clipped()
                .background(Color.random)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
        .onTapGesture {
            let group = group
            groupSelectAction?(group)
        }
    }
}

//struct ProfileGroupCell_Previews: PreviewProvider {
//    let group = Group(groupId: "", groupName: "dummyGroup", groupDescription: "더미 그룹입니다ㅠㅠ", posts: [], createUserId: "", managementUsers: [], shareMembers: [], startUsers: [], approvalWaitingUsers: [])
//
//    static var previews: some View {
//        GroupListCell(group: group, groupSelectAction: { group in
//            print("groupName")
//        })
////            .padding(.horizontal, 16)
//            .previewLayout(.sizeThatFits)
//    }
//}
