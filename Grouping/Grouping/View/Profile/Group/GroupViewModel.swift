//
//  GroupViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/23.
//

import Foundation
import Combine

protocol GroupViewModelInterface: ObservableObject {
    var group: Group { get set }
    var posts: [Post] { get set }
    
    func getPost()
}

final class GroupViewModel: GroupViewModelInterface {
    @Published var group: Group
    @Published var posts: [Post] = []
    
    private var subscriptions = Set<AnyCancellable>()
    private let fetchPostManager: FetchPostManagerInterface = FetchPostManager()
    
    init(group: Group) {
        self.group = group
        print("groupViewModel", #function)
        getPost()

        binding()
    }
    
    deinit {
        print("groupViewModel", #function)
    }
    
    func getPost() {
        fetchPostManager.getPosts(ids: group.posts) { [weak self] post in
            self?.posts = post
        }
    }
    
    private func binding() {
        NotificationCenter.default.publisher(for: .uploadPost)
            .sink { [weak self] noti in
                guard let self = self else { return }
                if let post = noti.userInfo?[FBFieldName.post] as? Post {
                    if self.group.id == post.groupId ?? "" {
                        self.posts.insert(post, at: 0)
                    }
                }
            }.store(in: &subscriptions)
    }
}
