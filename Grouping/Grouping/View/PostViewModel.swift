//
//  PostViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import Foundation

protocol PostViewModelInterface: ObservableObject {
    var post: Post { get set }
    var tags: [String] { get set }
    var images: [String] { get set }
    var content: String { get set }
    
    init(post: Post)
}

final class PostViewModel: PostViewModelInterface {
    @Published var post: Post {
        didSet {
            images = post.images
            tags = post.tags
            content = post.content
        }
    }
    @Published var images: [String] = []
    @Published var tags: [String] = []
    @Published var content: String = ""
    
    init(post: Post) {
        self.post = post
        images = post.images
        tags = post.tags
        content = post.content
    }
    
}
