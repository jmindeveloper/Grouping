//
//  Post.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import Foundation
import FirebaseFirestore

struct Post: Codable {
    let postId: String
    let createUserId: String
    let images: [String]
    let content: String
    let createdAt: String
    let location: CGFloat?
    var heartCount: Int
    var heartUsers: [String]
    var commentCount: Int
    var tags: [String]
}
