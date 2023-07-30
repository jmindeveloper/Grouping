//
//  UserListView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/25.
//

import SwiftUI

struct UserListView<VM>: View where VM: UserListViewModelInterface {
    @ObservedObject private var viewModel: VM
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ForEach(viewModel.users, id: \.id) { user in
            NavigationLink {
                LazyView(
                    ProfileView<ProfileViewModel>()
                        .environmentObject(ProfileViewModel(user: user))
                )
            } label: {
                UserListCell(user: user)
            }
        }
    }
}
