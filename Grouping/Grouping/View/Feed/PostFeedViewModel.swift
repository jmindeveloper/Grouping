//
//  PostFeedViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import Foundation

protocol PostFeedViewModelInterface: ObservableObject {
    var posts: [Post] { get set }
}

final class PostFeedViewModel: PostFeedViewModelInterface {
    @Published var posts: [Post] = []
    
    init(posts: [Post]) {
        self.posts = posts
    }
    
    init() {
        self.posts = dummyPostData
    }
}
