//
//  SearchViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/24.
//

import Foundation
import FirebaseFirestore

protocol SearchViewModelInterface: ObservableObject {
    var searchText: String { get set }
    
    func searchByUserName(completion: (([User]) -> Void)?)
}

final class SearchViewModel: SearchViewModelInterface {
    @Published var searchText: String = ""
    
    func searchByUserName(completion: (([User]) -> Void)? = nil) {
        
    }
}
