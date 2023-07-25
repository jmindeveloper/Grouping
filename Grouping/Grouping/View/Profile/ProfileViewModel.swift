//
//  ProfileViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import Foundation
import Combine

protocol ProfileViewModelInterface: ObservableObject {
    var user: User? { get set }
    var posts: [Post] { get set }
    var groups: [Group] { get set }
    var postCount: Int { get }
    var followerCount: Int { get }
    var followingCount: Int { get }
    var userIsMe: Bool { get }
    
    func getUserGroups()
    func follow()
}

final class ProfileViewModel: ProfileViewModelInterface {
    private var fetchPostManager: FetchPostManagerInterface?
    private var fetchGroupManager: FetchGroupManagerInterface?
    private let followManager: FollowManagementManagerInterface = FollowManagementManager()
    @Published var user: User?
    @Published var posts: [Post] = []
    @Published var groups: [Group] = []
    @Published var userIsMe: Bool
    
    private var subscriptions = Set<AnyCancellable>()
    
    var postCount: Int {
        posts.count
    }
    
    var followerCount: Int {
        return user?.followers.count ?? 0
    }
    
    var followingCount: Int {
        return user?.following.count ?? 0
    }
    
    init() {
        userIsMe = true
        if let user = UserAuthManager.shared.user {
            self.fetchPostManager = FetchPostManager(user: user)
            self.fetchGroupManager = FetchGroupManager(user: user)
            self.user = user
            getUserPosts()
        }
        binding()
    }
    
    init(user: User) {
        userIsMe = user.id == UserAuthManager.shared.user?.id
        self.fetchPostManager = FetchPostManager(user: user)
        self.fetchGroupManager = FetchGroupManager(user: user)
        self.user = user
        getUserPosts()
        binding()
    }
    
    private func binding() {
        NotificationCenter.default.publisher(for: .userLogin)
            .sink { [weak self] _ in
                if self?.userIsMe == true {
                    if let user = UserAuthManager.shared.user {
                        self?.fetchPostManager = FetchPostManager(user: user)
                        self?.fetchGroupManager = FetchGroupManager(user: user)
                        self?.user = user
                        self?.getUserPosts()
                    }
                }
            }.store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: .userUpdate)
            .sink { [weak self] _ in
            if self?.userIsMe == true {
                self?.user = UserAuthManager.shared.user
            }
        }.store(in: &subscriptions)
    }
    
    private func getUserPosts() {
        fetchPostManager?.getUserPosts { [weak self] posts in
            self?.posts = posts
            print("getPost --> ", posts.count)
        }
    }
    
    func getUserGroups() {
        fetchGroupManager?.getUserGroups { [weak self] groups in
            self?.groups = groups
            print(groups)
        }
    }
    
    func follow() {
        guard let user = user,
              user.id != UserAuthManager.shared.user?.id else {
            return
        }
        followManager.follow(subjectUser: user) {
            print("follow")
        }
    }
}
