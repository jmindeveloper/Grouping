//
//  GroupViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/23.
//

import Foundation

protocol GroupViewModelInterface: ObservableObject {
    var group: Group { get set }
    var posts: [Post] { get set }
    
    func getPost()
}

final class GroupViewModel: GroupViewModelInterface {
    @Published var group: Group
    @Published var posts: [Post] = []
    
    private let fetchPostManager: FetchPostManagerInterface = FetchPostManager()
    
    init(group: Group) {
        self.group = group; getPost()
    }
    
    func getPost() {
        fetchPostManager.getPosts(ids: group.posts) { [weak self] post in
            self?.posts = post
        }
    }
}
