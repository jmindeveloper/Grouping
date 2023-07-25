//
//  GroupSearchResultViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/25.
//

import Foundation
import FirebaseFirestore

final class GroupSearchResultViewModel: SearchResultViewModelInterface {
    private let searchManager: SearchManagerInterface = SearchManager()
    private let searchText: String
    @Published var groups: [Group] = []
    
    init(searchText: String) {
        self.searchText = searchText
        fetchSearchResult()
    }
    
    func fetchSearchResult() {
        searchManager.searchContainsField(collection: .Group, fieldName: "groupName", keyword: searchText) { [weak self] snapshot in
            for doc in snapshot {
                do {
                    let group = try doc.data(as: Group.self)
                    self?.groups.append(group)
                } catch {
                    print(error.localizedDescription)
                }
            }
            print("search Groups count is ", self?.groups.count)
        }
    }
}
