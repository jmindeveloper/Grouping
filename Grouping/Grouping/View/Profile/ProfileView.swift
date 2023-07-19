//
//  ProfileView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView<VM>: View where VM: ProfileViewModelInterface {
    @ObservedObject var viewModel: VM
    var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    var body: some View {
        ScrollView {
            userInfoView()
            
            albumGrid()
        }
        .navigationTitle(viewModel.user?.nickName ?? "Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func userInfoView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Image("test_image_5")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .padding(.leading, 16)
                
                Spacer()
                
                HStack {
                    bottomTitleTopValueView(title: "게시물", value: "56")
                        .padding(.horizontal, 6)
                    bottomTitleTopValueView(title: "팔로워", value: "282")
                        .padding(.horizontal, 6)
                    bottomTitleTopValueView(title: "팔로잉", value: "455")
                        .padding(.horizontal, 6)
                }
                
                Spacer()
            }
            
            Button {
                
            } label: {
                Text("프로필 편집")
                    .foregroundColor(.white)
            }
            .frame(width: Constant.screenWidth - 32, height: 35)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color(uc: .systemGray2)))
            .padding(.top)
            
            HStack {
                Button {
                    
                } label: {
                    Text("프로필 편집")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: Constant.screenWidth - 32, minHeight: 35)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color(uc: .systemGray2)))
                .padding(.top)
                
                Button {
                    
                } label: {
                    Text("프로필 편집")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: Constant.screenWidth - 32, minHeight: 35)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color(uc: .systemGray2)))
                .padding(.top)
            }
            .padding(.horizontal, 16)
            
            Divider()
                .padding(.top, 16)
        }
    }
    
    @ViewBuilder
    private func bottomTitleTopValueView(
        title: String,
        value: String
    ) -> some View {
        VStack {
            Text(value)
            Text(title)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}
