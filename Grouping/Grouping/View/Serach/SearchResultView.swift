//
//  SearchResultView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/24.
//

import SwiftUI

struct SearchResultView<VM>: View where VM: SearchResultViewModelInterface {
    @ObservedObject var viewModel: VM
    
    var body: some View {
        ScrollView {
            if let viewModel = viewModel as? UserSearchResultViewModel {
                ForEach(viewModel.users, id: \.id) { user in
                    NavigationLink {
                        Text(user.nickName)
                    } label: {
                        UserListCell(user: user)
                    }
                }
            } else if let viewModel = viewModel as? GroupSearchResultViewModel {
                ForEach(viewModel.groups) { group in
                    NavigationLink {
                        Text(group.groupName)
                    } label: {
                        ProfileGroupCell(group: group)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 3)
                    }
                }
            }
        }
    }
}
