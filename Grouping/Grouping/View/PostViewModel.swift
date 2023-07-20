//
//  PostViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import Foundation

protocol PostViewModelInterface: ObservableObject {
    var post: Post { get set }
    var userInfo: UserSimpleInfo? { get set }
    var tags: [String] { get set }
    var images: [String] { get set }
    var content: String { get set }
    var isHeart: Bool { get }
    var userBookMarkContains: Bool { get set }
    
    init(post: Post)
    
    func heart()
    func bookMark()
}

final class PostViewModel: PostViewModelInterface {
    private let user = UserAuthManager.shared.user
    @Published var userInfo: UserSimpleInfo? = nil
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
    @Published var userBookMarkContains: Bool
    var isHeart: Bool {
        post.heartUsers.contains(user?.id ?? "")
    }
    
    let interactionManager: PostInteractionManagerInterface = PostInteractionManager()
    let userFetchManager: FetchUserManagerInterface = FetchUserManager.default
    
    init(post: Post) {
        self.post = post
        self.userBookMarkContains = userFetchManager.starPostIds.contains(post.id)
        images = post.images
        tags = post.tags
        content = post.content
        
        userFetchManager.getUserSimpleInfo(userId: post.createUserId) { [weak self] user in
            self?.userInfo = user
        }
    }
    
    func heart() {
        guard let user = user else { return }
        interactionManager.heart(sender: user.id, post: post) { [weak self] post in
            self?.post = post
        }
    }
    
    func bookMark() {
        interactionManager.bookMark(post: post) { [weak self] ids in
            guard let self = self else { return }
            self.userBookMarkContains = ids.contains(self.post.id)
        }
    }
}
