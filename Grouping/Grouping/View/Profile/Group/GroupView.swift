//
//  GroupView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct GroupView<VM>: View where VM: GroupViewModelInterface {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: VM
    @State var showPostUploadView: Bool = false
    
    private var gradientColor: [Color] {
        if colorScheme == .dark {
            return [.clear, .black]
        } else {
            return [.clear, .white]
        }
    }
    
    private var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    @State var imageScale: CGFloat = 1 {
        didSet {
            if imageScale < 1 {
                imageScale = 1
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            ScrollOffsetView { offset in
                print(offset)
                imageScale = 1 + (offset / (Constant.screenWidth / 2))
            } content: {
                imageHeader()
                    .frame(maxWidth: Constant.screenWidth, minHeight: Constant.screenHeight / 2, maxHeight: Constant.screenHeight / 2)
                    .scaleEffect(CGSize(width: imageScale, height: imageScale))
                
                albumGrid()
                    .padding(.top, 15)
            }
            .ignoresSafeArea(edges: [.all])
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.primary)
                    }
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color(uiColor: .systemGray3)))
                    .shadow(radius: 5, x: 0, y: 5)
                    .contentShape(Rectangle())
                    
                    
                }
                .padding(.trailing, 18)
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showPostUploadView = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .frame(width: 35, height: 35)
                            .padding(14)
                            .background(
                                Circle().fill(.red).opacity(0.7)
                            )
                            .shadow(radius: 5, x: 3, y: 3)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.trailing, 19)
                .padding(.bottom)
            }
        }
        .onAppear {
            viewModel.isCanUpdateView = true
        }
        .onDisappear {
            viewModel.isCanUpdateView = false
        }
        .fullScreenCover(isPresented: $showPostUploadView) {
            LazyView(
                SelectImageView<PostUploadViewModel>(isTabPresent: false)
                    .environmentObject(PostUploadViewModel(group: viewModel.group))
                    .environment(\.dismissHear, $showPostUploadView)
            )
        }
    }
    
    @ViewBuilder
    private func imageHeader() -> some View {
        ZStack {
            WebImage(url: URL(string: viewModel.group.groupThumbnailImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: Constant.screenWidth, minHeight: Constant.screenHeight / 2, maxHeight: Constant.screenHeight / 2)
                .clipShape(Rectangle())
                .background(Color.red)
                .overlay(
                    LinearGradient(colors: gradientColor, startPoint: .center, endPoint: .bottom)
                )
            
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewModel.group.groupName)
                            .lineLimit(2)
                            .font(.system(size: 50, weight: .bold))
                            .shadow(radius: 1, x: 0, y: 1)
                        
                        Text(viewModel.group.groupDescription)
                            .lineLimit(3)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(.top)
                    }
                    .padding([.leading])
                    .padding(.bottom, 50)
                    
                    Spacer()
                    
                    NavigationLink {
                        LazyView(
                            ScrollView {
                                UserListView(viewModel: UserListViewModel(ids: viewModel.group.shareMembers))
                                    .foregroundColor(.primary)
                            }
                        )
                    } label: {
                        HStack {
                            Text("Members")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 50)
                    .padding(.trailing)
                }
            }
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

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView<GroupViewModel>()
            .environmentObject(GroupViewModel(group: Group(groupId: "dkldk", groupName: "더미그룹1", groupDescription: "더미그룹1ㅇㅁㄹㄴㅇㄹ", posts: [], createUserId: "", managementUsers: [], shareMembers: [], startUsers: [], approvalWaitingUsers: [])))
    }
}
