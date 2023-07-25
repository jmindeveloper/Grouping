//
//  PostFeedView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI

struct PostFeedView<VM>: View where VM: PostFeedViewModelInterface {
    @ObservedObject var viewModel: VM
    @State var scrollTag: String
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(viewModel.posts, id: \.self) { post in
                    PostView(viewModel: PostViewModel(post: post))
                        .padding(.vertical, 4)
                        .id(post.id)
                }
                .onChange(of: scrollTag) { tag in
                    proxy.scrollTo(tag, anchor: .top)
                }
                .onAppear {
                    proxy.scrollTo(scrollTag, anchor: .top)
                }
            }
        }
    }
}
