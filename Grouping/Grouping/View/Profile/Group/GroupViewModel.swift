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
    
    private let fetchPostManager: FetchPostManagerInterface
    
    init(group: Group) {
        self.group = group
        fetchPostManager = FetchPostManager(group: group)
        getPost()
    }
    
    func getPost() {
        fetchPostManager.getGroupPosts() { [weak self] post in
            self?.posts = post
        }
    }
}
