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
    var isHeart: Bool { get }
    
    init(post: Post)
    
    func heart()
}

final class PostViewModel: PostViewModelInterface {
    private let user = UserAuthManager.shared.user
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
    var isHeart: Bool {
        post.heartUsers.contains(user?.id ?? "")
    }
    
    let interactionManager: PostInteractionManagerInterface = PostInteractionManager()
    
    init(post: Post) {
        self.post = post
        images = post.images
        tags = post.tags
        content = post.content
    }
    
    func heart() {
        guard let user = user else { return }
        interactionManager.heart(sender: user.id, post: post) { [weak self] post in
            self?.post = post
        }
    }
}
