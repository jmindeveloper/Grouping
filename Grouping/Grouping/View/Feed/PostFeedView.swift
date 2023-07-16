//
//  PostFeedView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI

struct PostFeedView<VM>: View where VM: PostFeedViewModelInterface {
    @ObservedObject var viewModel: VM
    
    var body: some View {
        ScrollView {
            ScrollView {
                ForEach(viewModel.posts, id: \.self) { post in
                    PostView(post: post)
                        .padding(.vertical, 4)
                }
            }
        }
    }
}
