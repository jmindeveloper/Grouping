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
}

final class ProfileViewModel: ProfileViewModelInterface {
    private var userPostManager: UserPostManager?
    @Published var user: User?
    @Published var posts: [Post] = []
    private var userIsMe: Bool
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        userIsMe = true
        if let user = UserAuthManager.shared.user {
            self.userPostManager = UserPostManager(user: user)
            self.user = user
            getUserPosts()
        }
        binding()
    }
    
    init(user: User) {
        userIsMe = false
        self.userPostManager = UserPostManager(user: user)
        self.user = user
        getUserPosts()
        binding()
    }
    
    private func binding() {
        NotificationCenter.default.publisher(for: .userLogin)
            .sink { [weak self] _ in
                if self?.userIsMe == true {
                    if let user = UserAuthManager.shared.user {
                        self?.userPostManager = UserPostManager(user: user)
                        self?.user = user
                        self?.getUserPosts()
                    }
                }
            }.store(in: &subscriptions)
    }
    
    private func getUserPosts() {
        userPostManager?.getUserPosts { [weak self] posts in
            self?.posts = posts.reversed()
            print("getPost --> ", posts.count)
        }
    }
}
