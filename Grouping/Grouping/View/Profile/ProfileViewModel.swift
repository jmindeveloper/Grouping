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
    
    func getUserGroups()
}

final class ProfileViewModel: ProfileViewModelInterface {
    private var fetchPostManager: FetchPostManagerInterface?
    private var fetchGroupManager: FetchGroupManagerInterface?
    @Published var user: User?
    @Published var posts: [Post] = []
    @Published var groups: [Group] = []
    private var userIsMe: Bool
    
    private var subscriptions = Set<AnyCancellable>()
    
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
        userIsMe = false
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
}