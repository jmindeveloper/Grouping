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
    var isCanUpdateView: Bool { get set }
    
    func getPost()
}

final class GroupViewModel: GroupViewModelInterface {
    @Published var group: Group
    var posts: [Post] = [] {
        didSet {
            if isCanUpdateView {
                objectWillChange.send()
            }
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private let fetchPostManager: FetchPostManagerInterface = FetchPostManager()
    
    var isCanUpdateView: Bool = true {
        didSet {
            if isCanUpdateView {
                objectWillChange.send()
            }
        }
    }
    
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
        
        NotificationCenter.default.publisher(for: .deletePost)
            .sink { [weak self] noti in
                if let post = noti.userInfo?[FBFieldName.post] as? Post {
                    self?.posts.removeAll {
                        $0.id == post.id
                    }
                }
            }.store(in: &subscriptions)
    }
}
