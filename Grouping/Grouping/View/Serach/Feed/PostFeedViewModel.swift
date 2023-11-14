//
//  PostFeedViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import Foundation
import Combine

protocol PostFeedViewModelInterface: ObservableObject {
    var posts: [Post] { get set }
}

final class PostFeedViewModel: PostFeedViewModelInterface {
    @Published var posts: [Post] = []
    private var subscriptions = Set<AnyCancellable>()
    
    init(posts: [Post]) {
        self.posts = posts
        binding()
    }
    
    /// dummy post
    init() {
        self.posts = dummyPostData
    }
    
    private func binding() {
        NotificationCenter.default.publisher(for: .deletePost)
            .sink { [weak self] noti in
                if let post = noti.userInfo?[FBFieldName.post] as? Post {
                    self?.posts.removeAll {
                        $0.id == post.id
                    }
                }
            }.store(in: &subscriptions)
    }
}
