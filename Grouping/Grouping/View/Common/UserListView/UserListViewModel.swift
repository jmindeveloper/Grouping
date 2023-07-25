//
//  UserListViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/25.
//

import Foundation

protocol UserListViewModelInterface: ObservableObject {
    var users: [User] { get set }
    
    init(users: [User])
    init(ids: [String])
    
    func fetchUser(ids: [String], completion: (([User]) -> Void)?)
}

final class UserListViewModel: UserListViewModelInterface {
    @Published var users: [User] = []
    private let fetchUserManager: FetchUserManagerInterface = FetchUserManager()
    
    init(users: [User]) {
        self.users = users
    }
    
    init(ids: [String]) {
        fetchUser(ids: ids) { [weak self] users in
            self?.users = users
        }
    }
    
    func fetchUser(ids: [String], completion: (([User]) -> Void)?) {
        fetchUserManager.getUserList(ids: ids) { user in
            completion?(user)
        }
    }
}
