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
    var follower: [String] { get }
    var following: [String] { get }
    var userIsMe: Bool { get }
    var isCanUpdateView: Bool { get set }
    
    func getUserGroups()
    func follow()
}

final class ProfileViewModel: ProfileViewModelInterface {
    
    
    private var fetchPostManager: FetchPostManagerInterface?
    private var fetchGroupManager: FetchGroupManagerInterface?
    private let followManager: FollowManagementManagerInterface = FollowManagementManager()
    @Published var user: User?
    var posts: [Post] = [] {
        didSet {
            if isCanUpdateView {
                objectWillChange.send()
            }
        }
    }
    @Published var groups: [Group] = []
    @Published var userIsMe: Bool
    var isCanUpdateView: Bool = true {
        didSet {
            if isCanUpdateView {
                objectWillChange.send()
            }
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    var postCount: Int {
        posts.count
    }
    
    var follower: [String] {
        return user?.followers ?? []
    }
    
    var following: [String] {
        return user?.following ?? []
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
    
    deinit {
        print("profileViewModel", #function)
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
        
        NotificationCenter.default.publisher(for: .uploadPost)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noti in
                if let post = noti.userInfo?[FBFieldName.post] as? Post {
                    self?.posts.insert(post, at: 0)
                }
            }.store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: .deletePost)
            .sink { [weak self] noti in
                if let post = noti.userInfo?[FBFieldName.post] as? Post {
                    self?.posts.removeAll {
                        $0.id == post.id
                    }
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
