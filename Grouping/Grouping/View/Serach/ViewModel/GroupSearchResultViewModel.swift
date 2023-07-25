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
    var groups: [Group] = []
    
    init(searchText: String) { }
    
    func fetchSearchResult() {
        
    }
}
