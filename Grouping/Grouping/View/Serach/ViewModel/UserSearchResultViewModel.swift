//
//  UserSearchResultViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/25.
//

import Foundation
import FirebaseFirestore

protocol SearchResultViewModelInterface: ObservableObject {
    init(searchText: String)
    
    func fetchSearchResult()
}

final class UserSearchResultViewModel: SearchResultViewModelInterface {
    private let searchManager: SearchManagerInterface = SearchManager()
    private let searchText: String
    @Published var users: [User] = []
    
    init(searchText: String) {
        self.searchText = searchText
        fetchSearchResult()
    }
    
    func fetchSearchResult() {
        searchManager.searchContainsField(collection: .User, fieldName: "nickName", keyword: searchText) { [weak self] snapshot in
            for doc in snapshot {
                do {
                    let user = try doc.data(as: User.self)
                    self?.users.append(user)
                } catch {
                    print(error.localizedDescription)
                }
            }
            print("search Users count is ", self?.users.count)
        }
    }
}
