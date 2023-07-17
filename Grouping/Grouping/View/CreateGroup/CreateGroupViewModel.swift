//
//  CreateGroupViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/17.
//

import Foundation

protocol CreateGroupViewModelInterface: ObservableObject {
    var groupName: String { get set }
    var groupDescription: String { get set }
    var groupThumbnailImage: Data? { get set }
    
    func create(completion: ((Group) -> Void)?)
}

final class CreateGroupViewModel: CreateGroupViewModelInterface {
    let manager: GroupManagementManagerInterface = GroupManagementManager()
    
    @Published var groupName: String = ""
    @Published var groupDescription: String = ""
    @Published var groupThumbnailImage: Data? = nil
    
    func create(completion: ((Group) -> Void)? = nil) {
        manager.create(name: groupName, description: groupDescription, thumbnailImage: groupThumbnailImage) { group in
            completion?(group)
        }
    }
}
