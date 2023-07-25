//
//  TagSearchResultViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/25.
//

import Foundation
import FirebaseFirestore

final class TagSearchResultViewModel: SearchResultViewModelInterface {
    private let searchManager: SearchManagerInterface = SearchManager()
    private let searchText: String
    @Published var posts: [Post] = []
    
    init(searchText: String) {
        self.searchText = searchText
        fetchSearchResult()
    }
    
    func fetchSearchResult() {
        searchManager.searchEqualFieldToArray(collection: .Tag, fieldName: "tags", keyword: searchText) { [weak self] snapshot in
            for doc in snapshot {
                do {
                    let post = try doc.data(as: Post.self)
                    self?.posts.append(post)
                } catch {
                    print(error.localizedDescription)
                }
            }
            print("search Posts count is ", self?.posts.count)
        }
    }
}
