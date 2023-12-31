//
//  ProfileView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ProfileView<VM>: View where VM: ProfileViewModelInterface {
    @EnvironmentObject var viewModel: VM
    @State private var isShowPost: Bool = true
    @State private var createGroup: Bool = false
    
    @State private var selectedGroup: Group? = nil
    @State private var showFeedView: Bool = false
    
    private var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    var body: some View {
        ScrollView {
            userInfoView()
            
            if isShowPost {
                albumGrid()
            } else {
                GroupListView<ProfileViewModel> { group in
                    selectedGroup = group
                }
            }
        }
        .navigationTitle(viewModel.user?.nickName ?? "Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $createGroup) {
            LazyView(
                CreateGroupView(viewModel: CreateGroupViewModel())
            )
        }
        .fullScreenCover(item: $selectedGroup) { group in
            NavigationView {
                LazyView(
                GroupView<GroupViewModel>()
                    .environmentObject(GroupViewModel(group: group))
                    .navigationBarHidden(true))
            }
        }
        .onAppear {
            viewModel.isCanUpdateView = true
        }
        .onDisappear {
            viewModel.isCanUpdateView = false
        }
    }
    
    @ViewBuilder
    private func userInfoView() -> some View {
        VStack(spacing: 0) {
            HStack {
                WebImage(url: URL(string: viewModel.user?.profileImagePath ?? ""))
                    .placeholder(Image(systemName: "person.fill").resizable())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .padding(.leading, 16)
                
                Spacer()
                
                HStack {
                    bottomTitleTopValueView(title: "게시물", value: "\(viewModel.postCount)")
                        .padding(.horizontal, 6)
                    
                    NavigationLink {
                        ScrollView {
                            UserListView(viewModel: UserListViewModel(ids: viewModel.follower))
                        }
                        .navigationTitle("팔로워")
                    } label: {
                        bottomTitleTopValueView(title: "팔로워", value: "\(viewModel.follower.count)")
                            .contentShape(Rectangle())
                            .padding(.horizontal, 6)
                    }
                    .buttonStyle(.plain)
                    
                    NavigationLink {
                        ScrollView {
                            UserListView(viewModel: UserListViewModel(ids: viewModel.following))
                        }
                        .navigationTitle("팔로잉")
                    } label: {
                        bottomTitleTopValueView(title: "팔로잉", value: "\(viewModel.following.count)")
                            .contentShape(Rectangle())
                            .padding(.horizontal, 6)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
            
            if viewModel.userIsMe {
                NavigationLink {
                    LazyView(ProfileEditView(viewModel: ProfileEditViewModel()))
                } label: {
                    Text("프로필 편집")
                        .foregroundColor(.white)
                        .frame(width: Constant.screenWidth - 32, height: 35)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(uiColor: .systemGray2)))
                }
                .contentShape(Rectangle())
                .padding(.top)
            } else {
                Button {
                    viewModel.follow()
                } label: {
                    Text("팔로우")
                        .foregroundColor(.white)
                        .frame(width: Constant.screenWidth - 32, height: 35)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(uiColor: .blue)))
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .padding(.top)
            }
            
            ValueChangeToggleView(toggle: $isShowPost, lineColor: .red, leftTitle: "게시물", rightTitle: "그룹")
                .padding(.horizontal, 16)
                .frame(height: 35)
                .padding(.top, 13)
            
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
                .fontWeight(.semibold)
            Text(title)
                .font(.system(size: 14))
        }
    }
    
    @ViewBuilder
    private func albumGrid() -> some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 2, pinnedViews: .sectionFooters) {
            ForEach(viewModel.posts, id: \.id) { post in
                NavigationLink {
                    LazyView(
                        PostFeedView(viewModel: PostFeedViewModel(posts: viewModel.posts), scrollTag: post.id)
                    )
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
        ProfileView<ProfileViewModel>()
            .environmentObject(ProfileViewModel())
    }
}
