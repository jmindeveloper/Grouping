//
//  ProfileView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView<VM>: View where VM: ProfileViewModelInterface {
    @EnvironmentObject var viewModel: VM
    
    var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    var body: some View {
        ScrollView {
            albumGrid()
        }
        .navigationTitle(viewModel.user?.nickName ?? "Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ProfileGroupView<ProfileViewModel>()
                } label: {
                    Text("Group")
                }
            }
        }
    }
    
    @ViewBuilder
    private func albumGrid() -> some View {
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
