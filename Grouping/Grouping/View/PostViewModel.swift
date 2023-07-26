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
    var isMyPost: Bool { get }
    var group: Group? { get set }
    var timeText: String { get }
    
    init(post: Post)
    
    func heart()
    func bookMark()
    func deletePost()
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
    @Published var group: Group?
    var isMyPost: Bool {
        if (user?.id ?? "") == post.createUserId {
            return true
        } else {
            return false
        }
    }
    var isHeart: Bool {
        post.heartUsers.contains(user?.id ?? "")
    }
    
    var timeText: String {
        let difference = post.createdAt.hoursDifference()
        if difference.day < 1 {
            if difference.hour < 1 {
                if difference.min == 0 {
                    return "방금전"
                } else {
                    return "\(difference.min)분 전"
                }
            } else {
                return "\(difference.hour)시간 전"
            }
        } else {
            return post.createdAt.date2PostDateString()
        }
    }
    
    private let interactionManager: PostInteractionManagerInterface = PostInteractionManager()
    private let userFetchManager: FetchUserManagerInterface = FetchUserManager.default
    private let postManagementManager: PostManagementManagerInterface = PostManagementManager()
    private let fetchGroupManager: FetchGroupManagerInterface?
    
    init(post: Post) {
        self.post = post
        self.userBookMarkContains = userFetchManager.starPostIds.contains(post.id)
        images = post.images
        tags = post.tags
        content = post.content
        self.fetchGroupManager = FetchGroupManager(groupId: post.groupId)
        
        userFetchManager.getUserSimpleInfo(userId: post.createUserId) { [weak self] user in
            self?.userInfo = user
        }
        getGroup()
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
    
    func deletePost() {
        postManagementManager.delete(post: post) { isSuccess in
            
        }
    }
    
    func getGroup() {
        fetchGroupManager?.getGroup { [weak self] group in
            self?.group = group
        }
    }
}
