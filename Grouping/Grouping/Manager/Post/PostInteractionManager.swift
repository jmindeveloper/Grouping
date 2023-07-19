//
//  PostInteractionManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import Foundation

protocol PostInteractionManagerInterface {
    
}

final class PostInteractionManager: PostInteractionManagerInterface {
    func heart(sender userId: String, post: Post, completion: (() -> Void)? = nil) {
        
    }
    
    func bookMark(sender userId: String, post: Post, completion: (() -> Void)? = nil) {
        
    }
}
