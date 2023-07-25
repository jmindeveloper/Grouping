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
            ForEach((viewModel as! UserSearchResultViewModel).users, id: \.id) { user in
                NavigationLink {
                    Text(user.nickName)
                } label: {
                    UserListCell(user: user)
                }
            }
        }
    }
}
