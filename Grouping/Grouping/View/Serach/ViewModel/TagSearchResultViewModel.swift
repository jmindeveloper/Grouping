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
    var posts: [Post] = []
    
    init(searchText: String) { }
    
    func fetchSearchResult() {
        
    }
}
