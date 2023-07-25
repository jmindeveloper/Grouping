//
//  SearchResultView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchResultView<VM>: View where VM: SearchResultViewModelInterface {
    @ObservedObject var viewModel: VM
    @State private var selectedGroup: Group? = nil
    
    private var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            if let viewModel = viewModel as? UserSearchResultViewModel {
                ForEach(viewModel.users, id: \.id) { user in
                    NavigationLink {
                        ProfileView<ProfileViewModel>()
                            .environmentObject(ProfileViewModel(user: user))
                    } label: {
                        UserListCell(user: user)
                    }
                }
            } else if let viewModel = viewModel as? GroupSearchResultViewModel {
                ForEach(viewModel.groups) { group in
                    ProfileGroupCell(group: group)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 3)
                        .onTapGesture {
                            selectedGroup = group
                        }
                }
                .fullScreenCover(item: $selectedGroup) { group in
                    NavigationView {
                        GroupView<GroupViewModel>()
                            .environmentObject(GroupViewModel(group: group))
                    }
                }
            } else if let viewModel = viewModel as? TagSearchResultViewModel {
                albumGrid(viewModel: viewModel)
            }
        }
    }
    
    @ViewBuilder
    private func albumGrid(viewModel: TagSearchResultViewModel) -> some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 2, pinnedViews: .sectionFooters) {
            ForEach(viewModel.posts, id: \.id) { post in
                NavigationLink {
                    PostFeedView(viewModel: PostFeedViewModel(posts: viewModel.posts))
                } label: {
                    WebImage(url: URL(string: post.images[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (Constant.screenWidth - 4) / 3, height: (Constant.screenWidth - 4) / 3)
                        .clipped()
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

}
